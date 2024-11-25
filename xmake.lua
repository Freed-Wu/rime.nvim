-- luacheck: ignore 113
---@diagnostic disable: undefined-global
add_rules("mode.debug", "mode.release")

add_requires("rime")

target("rime")
do
    add_rules("luarocks.module")
    add_files("*.c")
    add_packages("rime")
end
