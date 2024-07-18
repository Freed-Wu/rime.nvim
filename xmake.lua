-- luacheck: ignore 113
-- xmake project -k compile_commands build
-- https://github.com/luarocks/luarocks/discussions/1695
add_rules("mode.debug", "mode.release")

-- Android Termux and ArchLinux's lua are not neovim's lua
local prefix = os.getenv("PREFIX") or "/usr"
add_includedirs(prefix .. "/include/luajit-2.1")
add_includedirs(prefix .. "/include/lua5.1")
add_requires("rime")

target("rime")
do
    add_rules("luarocks.module")
    add_files("*.c")
    add_packages("rime")
end
