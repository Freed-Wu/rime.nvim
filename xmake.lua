-- luacheck: ignore 111 113 143
---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field
add_rules("mode.debug", "mode.release")

add_requires("rime")

rule("lua-native-object")
do
    set_extensions(".nobj.lua")
    before_buildcmd_file(function(target, batchcmds, sourcefile, opt)
        -- get c source file for lua-native-object
        local dirname = path.join(target:autogendir(), "rules", "lua-native-object")
        local sourcefile_c = path.join(dirname, path.basename(sourcefile) .. ".c")

        -- add objectfile
        local objectfile = target:objectfile(sourcefile_c)
        table.insert(target:objectfiles(), objectfile)

        -- add commands
        batchcmds:show_progress(opt.progress, "${color.build.object}compiling.nobj.lua %s", sourcefile)
        batchcmds:mkdir(path.directory(sourcefile_c))
        batchcmds:vrunv("native_objects.lua",
            { "-outpath", dirname, "-gen", "lua", path(sourcefile) })
        batchcmds:compile(sourcefile_c, objectfile)

        -- add deps
        batchcmds:add_depfiles(sourcefile)
        batchcmds:set_depmtime(os.mtime(objectfile))
        batchcmds:set_depcache(target:dependfile(objectfile))
    end)
end

target("rime")
do
    add_includedirs(".")
    add_rules("luarocks.module", "lua-native-object", "c")
    add_files("*.nobj.lua")
    add_packages("rime")
end
