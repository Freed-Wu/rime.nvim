-- luacheck: ignore 113
---@diagnostic disable: undefined-global
c_module "rime" {
    use_globals = true,
    include "rime_api.h",
    c_source [[
      RimeApi *rime;
      #define BUFFER_SIZE 1024
    ]],
    c_source "module_init_src" [[
      rime = rime_get_api();
    ]],
    c_function "init" {
        var_in { "char *", "shared_data_dir" },
        var_in { "char *", "user_data_dir" },
        var_in { "char *", "log_dir" },
        var_in { "char *", "distribution_name" },
        var_in { "char *", "distribution_code_name" },
        var_in { "char *", "distribution_version" },
        var_in { "char *", "app_name" },
        var_in { "int", "min_log_level" },
        c_source [[
          RIME_STRUCT(RimeTraits, rime_traits);
          rime_traits.shared_data_dir = ${shared_data_dir};
          rime_traits.user_data_dir = ${user_data_dir};
          rime_traits.log_dir = ${log_dir};
          rime_traits.distribution_name = ${distribution_name};
          rime_traits.distribution_code_name = ${distribution_code_name};
          rime_traits.distribution_version = ${distribution_version};
          rime_traits.app_name = ${app_name};
          rime_traits.min_log_level = ${min_log_level};
          rime->setup(&rime_traits);
          rime->initialize(&rime_traits);
        ]]
    },
    c_function "get_schema_list" {
        var_out { "<any>", "result" },
        c_source [[
          RimeSchemaList schema_list;
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
        ]]
    },
    object "RimeSessionId" {
        constructor {
            c_call "RimeSessionId>1" "rime->create_session" {}
        },
        destructor "destroy" {
            c_method_call "bool" "rime->destroy_session" {}
        },
        method "get_current_schema" {
            var_out { "char *", "result" },
            c_source [[
              char schema_id[BUFFER_SIZE];
              if(!rime->get_current_schema(${this}, schema_id, BUFFER_SIZE))
                return 0;
              ${result} = schema_id;
            ]]
        },
        method "select_schema" {
            c_method_call "bool" "rime->select_schema" { "char *", "schema_id" }
        },
        method "process_key" {
            c_method_call "bool" "rime->process_key" { "int", "key", "int", "mask?" }
        },
        method "get_context" {
            var_out { "<any>", "result" },
            c_source [[
              RIME_STRUCT(RimeContext, context);
              if (!rime->get_context(${this}, &context))
                return 0;
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
            ]]
        },
        method "get_commit" {
            var_out { "<any>", "result" },
            c_source [[
              RIME_STRUCT(RimeCommit, commit);
              if(!rime->get_commit(${this}, &commit))
                return 0;
              lua_createtable(L, 0, 1);
              lua_pushstring(L, commit.text);
              lua_setfield(L, -2, "text");
              rime->free_commit(&commit);
            ]]
        },
        method "commit_composition" {
            c_method_call "bool" "rime->commit_composition" {}
        },
        method "clear_composition" {
            c_method_call "void" "rime->clear_composition" {}
        },
    }
}
