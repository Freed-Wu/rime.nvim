local nvim_rime = require('rime.nvim')

local source = {}

---callback
---@param id integer
---@param candidates table
function source._callback(id, candidates)
    source._callback_table[id]({
        items = candidates,
        isIncomplete = true
    })
    table.remove(source._callback_table, id)
end

source._callback_table = {}

---new
---@return table
function source.new()
    return setmetatable({}, { __index = source })
end

---get keyword pattern
---@return string
function source.get_keyword_pattern()
    return '\\%([!-~]\\)*'
end

-- luacheck: ignore 212/self
---complete
---@param request table
---@param callback table
function source:complete(request, callback)
    local keys = string.sub(request.context.cursor_before_line, request.offset)
    source._callback_table[request.context.id] = callback
    local cursor = request.context.cursor
    local context_id = request.context.id
    local menu = nvim_rime:get_context_with_all_candidates(keys).menu
    local items = {}
    for i, candidate in ipairs(menu.candidates) do
        local item = {
            label = candidate.text,
            filterText = keys,
            sortText = string.format("%08d", i),
            kind = 1,
            textEdit = {
                newText = candidate.text,
                range = {
                    start = {
                        line = cursor.row - 1,
                        character = cursor.col - #keys
                    },
                    ["end"] = {
                        line = cursor.row - 1,
                        character = cursor.col - 1
                    }
                }
            }
        }
        table.insert(items, item)
    end
    source._callback(context_id, items)
end

return source
