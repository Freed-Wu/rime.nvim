local git_ref = '$git_ref'
local modrev = '$modrev'
local specrev = '$specrev'

local repo_url = '$repo_url'

rockspec_format = '3.0'
package = '$package'
version = modrev ..'-'.. specrev

description = {
  summary = '$summary',
  detailed = $detailed_description,
  labels = $labels,
  homepage = '$homepage',
  $license
}

dependencies = $dependencies

test_dependencies = $test_dependencies

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = '$repo_name-' .. '$archive_dir_suffix',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git')
  }
end

build = {
  type = 'xmake',
  copy_directories = $copy_directories,
  -- https://github.com/xmake-io/luarocks-build-xmake/pull/3
  install = {
    lua = {
      ["rime.draw_ui"] = "lua/rime/draw_ui.lua",
      ["rime.parse_key"] = "lua/rime/parse_key.lua",
      ["rime.nvim.init"] = "lua/rime/nvim/init.lua",
      ["rime.nvim.config"] = "lua/rime/nvim/config.lua",
      ["rime.nvim.cmp-rime"] = "lua/rime/nvim/cmp-rime.lua",
    },
  },
}
