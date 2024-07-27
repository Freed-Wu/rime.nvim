local prefix = os.getenv("PREFIX") or "/usr"
local home = os.getenv("HOME") or "."
local shared_data_dir = ""
for _, dir in ipairs({
    prefix .. "/share/rime-data",
    "/usr/local/share/rime-data",
    "/run/current-system/sw/share/rime-data",
    "/sdcard/rime-data"
}) do
    -- luacheck: ignore 113
    ---@diagnostic disable: undefined-global
    if vim.fn.isdirectory(dir) == 1 then
        shared_data_dir = dir
    end
end
local user_data_dir = ""
for _, dir in ipairs({
    home .. "/.config/ibus/rime",
    home .. "/.local/share/fcitx5/rime",
    home .. "/.config/fcitx/rime",
    home .. "/sdcard/rime"
}) do
    if vim.fn.isdirectory(dir) == 1 then
        user_data_dir = dir
    end
end

local nowait_keys = { "!", "<Bar>", "}" }
-- "
for i = 0x23, 0x26 do
    local key = string.char(i)
    table.insert(nowait_keys, key)
end
-- '()
for i = 0x2a, 0x7b do
    local key = string.char(i)
    table.insert(nowait_keys, key)
end
local special_keys = { "<C-CR>", "<S-CR>", "<S-Tab>", "<BS>", "<M-BS>", "<C-Space>", "<M-C-Space>", "<M-Bar>" }
for _, keyname in ipairs({ "Up", "Down", "Left", "Right", "Home", "End", "PageUp", "PageDown" }) do
    for _, lhs in ipairs({ "<" .. keyname .. ">", "<C-" .. keyname .. ">", "<M-C-" .. keyname .. ">" }) do
        table.insert(special_keys, lhs)
    end
end
for i = 1, 35 do
    table.insert(special_keys, "<F" .. i .. ">")
end
for i = 0x41, 0x5f do
    local keyname = string.char(i)
    for _, lhs in ipairs({ "<C-" .. keyname .. ">", "<M-C-" .. keyname .. ">" }) do
        table.insert(special_keys, lhs)
    end
end
for i = 0x21, 0x7b do
    table.insert(special_keys, "<M-" .. string.char(i) .. ">")
end
-- <M-Bar>
for i = 0x7d, 0x7e do
    table.insert(special_keys, "<M-" .. string.char(i) .. ">")
end

return {
    preedit = "",
    has_set_keymaps = false,
    is_enabled = false,
    session_id = 0,
    win_id = 0,
    buf_id = 0,
    augroup_id = 0,
    configs = {
        disable_keys = { "<Space>" },
        nowait_keys = nowait_keys,
        special_keys = special_keys
    },
    traits = {
        shared_data_dir = shared_data_dir,
        user_data_dir = user_data_dir,
        log_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "rime"),
        distribution_name = "Rime",
        distribution_code_name = "nvim-rime",
        distribution_version = "0.0.1",
        app_name = "rime.nvim-rime",
        min_log_level = 3,
    },
    ui = {
        indices = { "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⓪" },
        left = "<|",
        right = "|>",
        left_sep = "[",
        right_sep = "]",
        cursor = "|",
    }
}
