-- luacheck: ignore 113
-- xmake project -k compile_commands build
-- https://github.com/luarocks/luarocks/discussions/1695
add_rules("mode.debug", "mode.release")

add_requires("rime")

target("rime")
do
    add_rules("luarocks.module")
    add_files("*.c")
    add_packages("rime")
end
