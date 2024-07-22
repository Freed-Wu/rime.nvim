local rime = require "rime"

local prefix = os.getenv("PREFIX") or "/usr"
local home = os.getenv("HOME") or "."
local shared_data_dir = ""
-- luacheck: ignore 112 113 212/self
---@diagnostic disable: undefined-global
for _, dir in ipairs({
    prefix .. "/share/rime-data",
    "/usr/local/share/rime-data",
    "/run/current-system/sw/share/rime-data",
    "/sdcard/rime-data"
}) do
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

local M = {
    preedit = "",
    has_set_keymaps = false,
    is_enabled = false,
    session_id = 0,
    win_id = 0,
    buf_id = 0,
    augroup_id = 0,
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

local special_keys = { "Up", "Down", "Left", "Right", "Home", "End", "PageUp", "PageDown" }

---setup
---@param conf table
function M:setup(conf)
    M = vim.tbl_deep_extend("keep", conf, M)
end

---process key
---@param key string
---@param modifiers string[]
function M:process_key(key, modifiers)
    modifiers = modifiers or {}
    local keycode, mask = require("nvim-rime.parse_key")(key, modifiers)
    return rime.processKey(M.session_id, keycode, mask)
end

---process keys
---@param keys string
---@param modifiers string[]
function M:process_keys(keys, modifiers)
    modifiers = modifiers or {}
    for key in keys:gmatch("(.)") do
        if M:process_key(key, modifiers) == false then
            return false
        end
    end
    return true
end

---get callback for draw UI
---@param key string
function M:callback(key)
    return function()
        if M.is_enabled then
            return M:draw_ui(key)
        end
    end
end

---get rime commit
function M:get_commit_text()
    if rime.commitComposition(M.session_id) then
        return rime.getCommit(M.session_id).text
    end
    return ""
end

---reset keymaps
function M:reset_keymaps()
    if M.preedit ~= "" and M.has_set_keymaps == false then
        for _, keyname in ipairs(special_keys) do
            local lhs = "<" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
            lhs = "<C-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
            lhs = "<M-C-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
        end
        for i = 1, 35 do
            local keyname = "F" .. i
            local lhs = "<" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
        end
        vim.api.nvim_buf_set_keymap(0, "i", "<C-CR>", "",
            { noremap = true, nowait = true, callback = M:callback("<C-CR>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<S-CR>", "",
            { noremap = true, nowait = true, callback = M:callback("<S-CR>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<S-Tab>", "",
            { noremap = true, nowait = true, callback = M:callback("<S-Tab>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<BS>", "",
            { noremap = true, nowait = true, callback = M:callback("<BS>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<M-BS>", "",
            { noremap = true, nowait = true, callback = M:callback("<M-BS>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<C-Space>", "",
            { noremap = true, nowait = true, callback = M:callback("<C-Space>"), })
        vim.api.nvim_buf_set_keymap(0, "i", "<M-C-Space>", "",
            { noremap = true, nowait = true, callback = M:callback("<M-C-Space>"), })
        for i = 0x41, 0x5f do
            local keyname = string.char(i)
            local lhs = "<C-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
            lhs = "<M-C-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
        end
        for i = 0x21, 0x7b do
            local keyname = string.char(i)
            local lhs = "<M-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
        end
        vim.api.nvim_buf_set_keymap(0, "i", "<M-Bar>", "<M-Bar>", { noremap = true, nowait = true })
        for i = 0x7d, 0x7e do
            local keyname = string.char(i)
            local lhs = "<M-" .. keyname .. ">"
            vim.api.nvim_buf_set_keymap(0, "i", lhs, "",
                { noremap = true, nowait = true, callback = M:callback(lhs), })
        end
        M.has_set_keymaps = true
    elseif M.preedit == "" and M.has_set_keymaps == true then
        for _, keyname in ipairs(special_keys) do
            vim.api.nvim_buf_del_keymap(0, "i", "<" .. keyname .. ">")
            vim.api.nvim_buf_del_keymap(0, "i", "<C-" .. keyname .. ">")
            vim.api.nvim_buf_del_keymap(0, "i", "<M-C-" .. keyname .. ">")
        end
        for i = 1, 35 do
            local keyname = "F" .. i
            vim.api.nvim_buf_del_keymap(0, "i", "<" .. keyname .. ">")
        end
        vim.api.nvim_buf_del_keymap(0, "i", "<C-CR>")
        vim.api.nvim_buf_del_keymap(0, "i", "<S-CR>")
        vim.api.nvim_buf_del_keymap(0, "i", "<S-Tab>")
        vim.api.nvim_buf_del_keymap(0, "i", "<BS>")
        vim.api.nvim_buf_del_keymap(0, "i", "<M-BS>")
        vim.api.nvim_buf_del_keymap(0, "i", "<C-Space>")
        vim.api.nvim_buf_del_keymap(0, "i", "<M-C-Space>")
        for i = 0x41, 0x5f do
            local keyname = string.char(i)
            vim.api.nvim_buf_del_keymap(0, "i", "<C-" .. keyname .. ">")
            vim.api.nvim_buf_del_keymap(0, "i", "<M-C-" .. keyname .. ">")
        end
        for i = 0x21, 0x7b do
            local keyname = string.char(i)
            vim.api.nvim_buf_del_keymap(0, "i", "<M-" .. keyname .. ">")
        end
        vim.api.nvim_buf_del_keymap(0, "i", "<M-Bar>")
        for i = 0x7d, 0x7e do
            local keyname = string.char(i)
            vim.api.nvim_buf_del_keymap(0, "i", "<M-" .. keyname .. ">")
        end
        M.has_set_keymaps = false
    end
end

---feed keys
---@param text string
function M:feed_keys(text)
    if vim.v.char ~= "" then
        vim.v.char = text
    else
        -- cannot work
        -- vim.api.nvim_feedkeys(text, 't', true)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local r = cursor[1]
        local c = cursor[2]
        vim.api.nvim_buf_set_text(0, r - 1, c, r - 1, c, { text })
        vim.api.nvim_win_set_cursor(0, { r, c + #text })
    end
    M:win_close()
    M.preedit = ""
    M:reset_keymaps()
end

---draw UI
---@param key string
function M:draw_ui(key)
    if key == "" then
        key = vim.v.char
    end
    if M:process_key(key, {}) == false then
        if #key == 1 then
            M:feed_keys(key)
        end
        return
    end
    local context = rime.getContext(M.session_id)
    if context.menu.num_candidates == 0 then
        M:feed_keys(M:get_commit_text())
        return
    end
    vim.v.char = ""
    M.preedit = context.composition.preedit or ""
    local preedit = M.preedit:sub(1, context.composition.cursor_pos) ..
        M.ui.cursor .. M.preedit:sub(context.composition.cursor_pos + 1)
    local candidates = context.menu.candidates
    local candidates_ = ""
    local indices = M.ui.indices
    for index, _ in ipairs(candidates) do
        local candidate = candidates[index]
        local text = indices[index] .. " " .. candidate.text
        if candidate.comment ~= nil then
            text = text .. " " .. candidate.comment
        end
        if (context.menu.highlighted_candidate_index + 1 == index) then
            text = M.ui.left_sep .. text
        elseif (context.menu.highlighted_candidate_index + 2 == index) then
            text = M.ui.right_sep .. text
        else
            text = " " .. text
        end
        candidates_ = candidates_ .. text
    end
    if (context.menu.num_candidates == context.menu.highlighted_candidate_index + 1) then
        candidates_ = candidates_ .. M.ui.right_sep
    else
        candidates_ = candidates_ .. " "
    end
    local col = 0
    local left = M.ui.left
    if context.menu.page_no ~= 0 then
        local num = vim.api.nvim_strwidth(left)
        candidates_ = left .. candidates_
        local whitespace = " "
        preedit = whitespace:rep(num) .. preedit
        col = col - num
    end
    if (context.menu.is_last_page == false and #candidates > 0) then
        candidates_ = candidates_ .. M.ui.right
    end
    local lines = { preedit, candidates_ }
    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(vim.api.nvim_strwidth(line), width)
    end
    local config = {
        relative = "cursor",
        height = #lines,
        style = "minimal",
        width = width,
        row = 1,
        col = col,
    }
    if M.buf_id == 0 or not vim.api.nvim_buf_is_valid(M.buf_id) then
        M.buf_id = vim.api.nvim_create_buf(false, true)
    end
    vim.schedule(
        function()
            vim.api.nvim_buf_set_lines(M.buf_id, 0, #lines, false, lines)
            if (M.win_id == 0 or not vim.api.nvim_win_is_valid(M.win_id)) then
                M.win_id = vim.api.nvim_open_win(M.buf_id, false, config)
            else
                vim.api.nvim_win_set_config(M.win_id, config)
            end
        end
    )
    M:reset_keymaps()
end

---close IME window
function M:win_close()
    vim.schedule(
        function()
            if M.win_id ~= 0 and vim.api.nvim_win_is_valid(M.win_id) then
                vim.api.nvim_win_close(M.win_id, false)
            end
            M.win_id = 0
        end
    )
end

---clear composition
function M:clearComposition()
    rime.clearComposition(M.session_id)
end

---initial
function M:init()
    if M.session_id == 0 then
        vim.fn.mkdir(M.traits.log_dir, "p")
        rime.init(M.traits)
        M.session_id = rime.createSession()
    end
end

---enable IME
function M:enable()
    M:init()
    vim.api.nvim_buf_set_keymap(0, "i", "<Space>", "<Space>", { noremap = true, nowait = true })
    for i = 0x21, 0x7b do
        local key = string.char(i)
        vim.api.nvim_buf_set_keymap(0, "i", key, key, { noremap = true, nowait = true })
    end
    vim.api.nvim_buf_set_keymap(0, "i", "<Bar>", "<Bar>", { noremap = true, nowait = true })
    for i = 0x7d, 0x7e do
        local key = string.char(i)
        vim.api.nvim_buf_set_keymap(0, "i", key, key, { noremap = true, nowait = true })
    end

    M.augroup_id = vim.api.nvim_create_augroup("rime", {})
    vim.api.nvim_create_autocmd("InsertCharPre", {
        group = M.augroup_id,
        buffer = 0,
        callback = M:callback(""),
    })
    vim.api.nvim_create_autocmd({ "InsertLeave", "WinLeave" }, {
        group = M.augroup_id,
        buffer = 0,
        callback = function()
            M:clearComposition()
            M:win_close()
        end
    })
    M.is_enabled = true
end

---disable IME
function M:disable()
    vim.api.nvim_buf_del_keymap(0, "i", "<Space>")
    for i = 0x21, 0x7b do
        local key = string.char(i)
        vim.api.nvim_buf_del_keymap(0, "i", key)
    end
    vim.api.nvim_buf_del_keymap(0, "i", "<Bar>")
    for i = 0x7d, 0x7e do
        local key = string.char(i)
        vim.api.nvim_buf_del_keymap(0, "i", key)
    end

    vim.api.nvim_del_augroup_by_id(M.augroup_id)
    M.is_enabled = false
end

---get context with all candidates
---@param keys string
---@return table
function M:get_context_with_all_candidates(keys)
    M:init()
    M:process_keys(keys, {})
    local context = rime.getContext(M.sessionId)
    if (keys ~= '') then
        local result = context
        while (not context.menu.is_last_page) do
            M:process_key('=', {})
            context = rime.getContext(M.sessionId)
            result.menu.num_candidates = result.menu.num_candidates + context.menu.num_candidates
            if (result.menu.select_keys and context.menu.select_keys) then
                table.insert(result.menu.select_keys, context.menu.select_keys)
            end
            if (result.menu.candidates and context.menu.candidates) then
                table.insert(result.menu.candidates, context.menu.candidates)
            end
        end
    end
    M:clearComposition()
    return context
end

---toggle IME
function M:toggle()
    if M.is_enabled then
        M:disable()
    else
        M:enable()
    end
end

return M
