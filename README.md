# rime.nvim

[![readthedocs](https://shields.io/readthedocs/rime-nvim)](https://rime-nvim.readthedocs.io)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Freed-Wu/rime.nvim/main.svg)](https://results.pre-commit.ci/latest/github/Freed-Wu/rime.nvim/main)
[![github/workflow](https://github.com/Freed-Wu/rime.nvim/actions/workflows/main.yml/badge.svg)](https://github.com/Freed-Wu/rime.nvim/actions)

[![github/downloads](https://shields.io/github/downloads/Freed-Wu/rime.nvim/total)](https://github.com/Freed-Wu/rime.nvim/releases)
[![github/downloads/latest](https://shields.io/github/downloads/Freed-Wu/rime.nvim/latest/total)](https://github.com/Freed-Wu/rime.nvim/releases/latest)
[![github/issues](https://shields.io/github/issues/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/discussions)
[![github/milestones](https://shields.io/github/milestones/all/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/milestones)
[![github/forks](https://shields.io/github/forks/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/network/members)
[![github/stars](https://shields.io/github/stars/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/stargazers)
[![github/watchers](https://shields.io/github/watchers/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/watchers)
[![github/contributors](https://shields.io/github/contributors/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/commits)
[![github/release-date](https://shields.io/github/release-date/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/releases/latest)

[![github/license](https://shields.io/github/license/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)
[![github/languages/top](https://shields.io/github/languages/top/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)
[![github/directory-file-count](https://shields.io/github/directory-file-count/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)
[![github/code-size](https://shields.io/github/languages/code-size/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)
[![github/repo-size](https://shields.io/github/repo-size/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)
[![github/v](https://shields.io/github/v/release/Freed-Wu/rime.nvim)](https://github.com/Freed-Wu/rime.nvim)

[![luarocks](https://img.shields.io/luarocks/v/Freed-Wu/rime.nvim)](https://luarocks.org/modules/Freed-Wu/rime.nvim)

Rime for neovim.

Like [coc-rime](https://github.com/tonyfettes/coc-rime).
However, use lua not javascript.

![screencast](https://github.com/user-attachments/assets/71882a57-d4dd-4898-8eee-b7a17ae5193f)

## Dependence

- [librime](https://github.com/rime/librime)

```sh
# Ubuntu
sudo apt-get -y install librime-dev librime1
sudo apt-mark auto librime-dev
# ArchLinux
sudo pacman -S librime
# Android Termux
apt-get -y install librime
# Nix
# use nix-shell to create a virtual environment then build
# homebrew
brew install librime pkg-config
# Windows msys2
pacboy -S --noconfirm pkg-config librime gcc
```

## Install

### rocks.nvim

#### Command style

```vim
:Rocks install rime.nvim
```

#### Declare style

`~/.config/nvim/rocks.toml`:

```toml
[plugins]
"rime.nvim" = "scm"
```

Then

```vim
:Rocks sync
```

or:

```sh
$ luarocks --lua-version 5.1 --local --tree ~/.local/share/nvim/rocks install rime.nvim
# ~/.local/share/nvim/rocks is the default rocks tree path
# you can change it according to your vim.g.rocks_nvim.rocks_path
```

## Configure

Refer [config](https://rime-nvim.readthedocs.io/en/latest/modules/lua.rime.config.html):

```lua
require('rime.nvim').setup({
    -- ...
})
```

Set keymap:

```lua
vim.keymap.set('i', '<C-^>', require('rime.nvim').toggle)
```

Once it is enabled, any printable key will be passed to rime in any case while
any non-printable key will be passed to rime only if rime window is opened. If
you want to pass a key to rime in any case, try:

```lua
vim.keymap.set('i', '<C-\\>', require('rime.nvim').callback('<C-\\>'))
```

It is useful for some key such as the key for switching input schema.

Once you switch to ascii mode of rime, you **cannot** switch back unless you
have defined any hotkey to pass the key for switching ascii mode of rime to rime.
Because only printable key can be passed to rime when rime window is closed.

For cursor color,

```vim
set guicursor=n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25-CursorIM/lCursorIM,r-cr-o:hor20-CursorIM/lCursorIM
```

```lua
require('rime.nvim').setup({
    cursor = {
        default = { bg = 'white' },
        double_pinyin_mspy = { bg = 'red' },
        japanese = { bg = 'yellow' }
    }
})
```

![ASCII](https://github.com/user-attachments/assets/2e45a3b3-195e-45c9-a99a-0c49e95fda56)

![MSPY](https://github.com/user-attachments/assets/05f9e142-0357-452b-b466-d25d06cdd954)

![japanese](https://github.com/user-attachments/assets/706ce7a7-9aa7-4e62-8ca6-af6dde799776)

## Integration

### [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

Like [cmp-rime](https://github.com/Ninlives/cmp-rime):

```lua
require('cmp').setup {
  -- ...
  sources = {
    -- ...
    { name = 'rime' }
  }
}
```

### [vim-airline](https://github.com/vim-airline/vim-airline/)

In insert/replace/select/... mode, it will display current input schema name.

You can customize it. Such as:

Only display input schema name in insert mode:

```lua
require('rime.nvim').setup({
  get_new_symbol = function (old, name)
    if old == M.airline_mode_map.i
      return name
    end
    return old
  end
})
```

See airline's `g:airline_mode_map` to know `i`, `R`, `s`, ...

Disable this feature:

```lua
require('rime.nvim').setup({
  update_status_bar = function () end
})
```

## Tips

For Nix user, run
`/the/path/of/luarocks/rocks-5.1/rime.nvim/VERSION/scripts/update.sh` when
dynamic link libraries are broken after `nix-collect-garbage -d`.

## Related Projects

- [A collection](https://github.com/Freed-Wu/ime.nvim) of the solutions to
  input CJKV characters in vim
- [A collection](https://github.com/rime/librime#frontends) of rime frontends
