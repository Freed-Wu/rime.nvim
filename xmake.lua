-- luacheck: ignore 113
---@diagnostic disable: undefined-global
add_rules("mode.debug", "mode.release")

add_requires("rime")

includes("@builtin/check")
add_configfiles("config.h.in")
configvar_check_cincludes("RIME_API_DEPRECATED", "rime_api_deprecated.h")

target("rime")
do
    add_rules("luarocks.module")
    add_includedirs("$(buildir)")
    add_files("*.c")
    add_packages("rime")
end
