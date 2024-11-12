#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

nix-shell --run 'luarocks install --lua-version 5.1 --force --local rime.nvim'
