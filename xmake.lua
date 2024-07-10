-- xmake project -k compile_commands
-- https://github.com/luarocks/luarocks/discussions/1695
add_rules("mode.debug", "mode.release")

add_requires("rime")
add_requires("luajit")

target("rime")
do
    set_kind("shared")
    add_files("*.c")
    add_packages("rime")
    add_packages("luajit")
end
