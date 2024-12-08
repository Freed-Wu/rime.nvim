#include <lauxlib.h>
#include <rime_api.h>

#define DEFAULT_BUFFER_SIZE 1024

static RimeApi *rime;

static int init(lua_State *L) {
  rime = rime_get_api();
  RIME_STRUCT(RimeTraits, rime_traits);
  lua_getfield(L, 1, "shared_data_dir");
  rime_traits.shared_data_dir = lua_tostring(L, -1);
  lua_getfield(L, 1, "user_data_dir");
  rime_traits.user_data_dir = lua_tostring(L, -1);
  lua_getfield(L, 1, "log_dir");
  rime_traits.log_dir = lua_tostring(L, -1);
  lua_getfield(L, 1, "distribution_name");
  rime_traits.distribution_name = lua_tostring(L, -1);
  lua_getfield(L, 1, "distribution_code_name");
  rime_traits.distribution_code_name = lua_tostring(L, -1);
  lua_getfield(L, 1, "distribution_version");
  rime_traits.distribution_version = lua_tostring(L, -1);
  lua_getfield(L, 1, "app_name");
  rime_traits.app_name = lua_tostring(L, -1);
  lua_getfield(L, 1, "min_log_level");
  rime_traits.min_log_level = lua_tointeger(L, -1);
  rime->setup(&rime_traits);
  rime->initialize(&rime_traits);
  return 0;
}

static int finalize(lua_State *L) {
  rime->finalize();
  return 0;
}

static int create_session(lua_State *L) {
  RimeSessionId session_id = rime->create_session();
  if (session_id == 0)
    fputs("cannot create session", stderr);
  lua_pushinteger(L, session_id);
  return 1;
}

static int destroy_session(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  Bool ret = rime->destroy_session(session_id);
  if (!ret)
    fprintf(stderr, "cannot destroy session %lu\n", session_id);
  lua_pushboolean(L, ret);
  return 0;
}

static int get_current_schema(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  char buffer[DEFAULT_BUFFER_SIZE] = "";
  if (!rime->get_current_schema(session_id, buffer, DEFAULT_BUFFER_SIZE)) {
    fprintf(stderr, "cannot get current schema for session %lu\n", session_id);
    return 0;
  }
  lua_pushstring(L, buffer);
  return 1;
}

static int get_schema_list(lua_State *L) {
  RimeSchemaList schema_list = {};
  if (!rime->get_schema_list(&schema_list)) {
    fputs("cannot get schema list", stderr);
    return 0;
  }
  lua_newtable(L);
  for (size_t i = 0; i < schema_list.size; i++) {
    lua_createtable(L, 0, 2);
    lua_pushstring(L, schema_list.list[i].schema_id);
    lua_setfield(L, -2, "schema_id");
    lua_pushstring(L, schema_list.list[i].name);
    lua_setfield(L, -2, "name");
    lua_rawseti(L, -2, i + 1);
  }
  return 1;
}

static int select_schema(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  Bool ret = rime->select_schema(session_id, lua_tostring(L, 2));
  if (!ret)
    fprintf(stderr, "cannot select schema for session %lu\n", session_id);
  lua_pushboolean(L, ret);
  return 1;
}

static int process_key(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  int key = lua_tointeger(L, 2);
  int mask = lua_tointeger(L, 3);
  lua_pushboolean(L, rime->process_key(session_id, key, mask));
  return 1;
}

static int get_context(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  RIME_STRUCT(RimeContext, context);
  if (!rime->get_context(session_id, &context)) {
    fprintf(stderr, "cannot get context for session %lu\n", session_id);
    return 0;
  }
  lua_createtable(L, 0, 2);
  lua_createtable(L, 0, 5);
  lua_pushinteger(L, context.composition.length);
  lua_setfield(L, -2, "length");
  lua_pushinteger(L, context.composition.cursor_pos);
  lua_setfield(L, -2, "cursor_pos");
  lua_pushinteger(L, context.composition.sel_start);
  lua_setfield(L, -2, "sel_start");
  lua_pushinteger(L, context.composition.sel_end);
  lua_setfield(L, -2, "sel_end");
  lua_pushstring(L, context.composition.preedit);
  lua_setfield(L, -2, "preedit");
  lua_setfield(L, -2, "composition");
  lua_createtable(L, 0, 7);
  lua_pushinteger(L, context.menu.page_size);
  lua_setfield(L, -2, "page_size");
  lua_pushinteger(L, context.menu.page_no);
  lua_setfield(L, -2, "page_no");
  lua_pushboolean(L, context.menu.is_last_page);
  lua_setfield(L, -2, "is_last_page");
  lua_pushinteger(L, context.menu.highlighted_candidate_index);
  lua_setfield(L, -2, "highlighted_candidate_index");
  lua_pushinteger(L, context.menu.num_candidates);
  lua_setfield(L, -2, "num_candidates");
  lua_pushstring(L, context.menu.select_keys);
  lua_setfield(L, -2, "select_keys");
  lua_newtable(L);
  for (int i = 0; i < context.menu.num_candidates; ++i) {
    lua_createtable(L, 0, 2);
    lua_pushstring(L, context.menu.candidates[i].text);
    lua_setfield(L, -2, "text");
    lua_pushstring(L, context.menu.candidates[i].comment);
    lua_setfield(L, -2, "comment");
    lua_rawseti(L, -2, i + 1);
  }
  lua_setfield(L, -2, "candidates");
  lua_setfield(L, -2, "menu");
  rime->free_context(&context);
  return 1;
}

static int get_commit(lua_State *L) {
  RimeSessionId session_id = lua_tointeger(L, 1);
  RIME_STRUCT(RimeCommit, commit);
  if (!rime->get_commit(session_id, &commit)) {
    fprintf(stderr, "cannot get commit for session %lu\n", session_id);
    return 0;
  }
  lua_createtable(L, 0, 1);
  lua_pushstring(L, commit.text);
  lua_setfield(L, -2, "text");
  rime->free_commit(&commit);
  return 1;
}

static int commit_composition(lua_State *L) {
  lua_pushboolean(L, rime->commit_composition(lua_tointeger(L, 1)));
  return 1;
}

static int clear_composition(lua_State *L) {
  rime->clear_composition(lua_tointeger(L, 1));
  return 0;
}

static const luaL_Reg functions[] = {
    {"init", init},
    {"create_session", create_session},
    {"destroy_session", destroy_session},
    {"get_current_schema", get_current_schema},
    {"get_schema_list", get_schema_list},
    {"select_schema", select_schema},
    {"process_key", process_key},
    {"get_context", get_context},
    {"get_commit", get_commit},
    {"commit_composition", commit_composition},
    {"clear_composition", clear_composition},
    {"finalize", finalize},
    {NULL, NULL},
};

int luaopen_rime(lua_State *L) {
#if LUA_VERSION_NUM == 501
  luaL_register(L, "rime", functions);
#else
  luaL_newlib(L, functions);
#endif
  return 1;
}
