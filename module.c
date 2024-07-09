#include <lualib.h>
#include <lauxlib.h>
#include <rime_api.h>

int luaopen_rime(lua_State* L) {
    lua_pushstring(L, "hello");
    return 1;
}
