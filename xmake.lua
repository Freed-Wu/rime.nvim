-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field
add_rules("mode.debug", "mode.release")

add_requires("rime")

target("rime")
do
    add_rules("luarocks.module", "lua.native-object", "c")
    add_files("*.nobj.lua")
    add_packages("rime")
end
