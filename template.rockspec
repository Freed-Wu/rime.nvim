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

external_dependencies = {
  RIME = {
    header = "rime_api.h",
    library = "rime",
  },
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
  type = 'builtin',
  copy_directories = $copy_directories,
  modules = {
    rime = {
      sources = {
        "rime.c"
      },

      incdirs = {
        "$(RIME_INCDIR)",
      },

      libdirs = {
        "$(RIME_LIBDIR)",
      },

      libraries = {
        "rime"
      }
    }
  }
}
