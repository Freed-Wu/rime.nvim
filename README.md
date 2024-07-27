# rime.nvim

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

![screencast](https://github.com/user-attachments/assets/c188d2e5-d65a-4d60-92a7-a5cad993fc0e)

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

By default,

```lua
local prefix = os.getenv('PREFIX') or '/usr'
local home = os.getenv('HOME') or '.'
local shared_data_dir = ""
for _, dir in ipairs({
    prefix .. '/share/rime-data',
    '/usr/local/share/rime-data',
    '/run/current-system/sw/share/rime-data',
    '/sdcard/rime-data'
}) do
    if vim.fn.isdirectory(dir) == 1 then
        shared_data_dir = dir
    end
end
local user_data_dir = ""
for _, dir in ipairs({
    home .. '/.config/ibus/rime',
    home .. '/.local/share/fcitx5/rime',
    home .. '/.config/fcitx/rime',
    home .. '/sdcard/rime'
}) do
    if vim.fn.isdirectory(dir) == 1 then
        user_data_dir = dir
    end
end
require('nvim-rime').setup({
        configs = {
            disable_keys = { "<Space>" },
        },
        traits = {
            shared_data_dir = shared_data_dir,
            user_data_dir = user_data_dir,
            log_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'rime'),
            distribution_name = 'Rime',
            distribution_code_name = 'nvim-rime',
            distribution_version = '0.0.1',
            app_name = 'rime.nvim-rime',
            min_log_level = 3,
        },
        ui = {
            indices = {'①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', '⓪'},
            left = '<|',
            right = '|>',
            left_sep = '[',
            right_sep = ']',
            cursor = '|',
        }
    }
)
```

Set keymap:

```lua
vim.api.nvim_set_keymap('i', '<C-^>', '', {noremap = true, callback = require('nvim-rime').toggle}
```

Once it is enabled, any printable key will be passed to rime in any case while
any non-printable key will be passed to rime only if rime window is opened. If
you want to pass a key to rime in any case, try:

```lua
vim.api.nvim_set_keymap('i', '<C-\\>', '', {noremap = true, callback = require('nvim-rime'):callback('<C-\\>')})
```

It is useful for some key such as the key for switching input schema.

Once you switch to ascii mode of rime, you **cannot** switch back unless you
have defined any hotkey to pass the key for switching ascii mode of rime to rime.
Because only printable key can be passed to rime when rime window is closed.

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

## Similar Projects

- [zsh-rime](https://github.com/Freed-Wu/zsh-rime)
