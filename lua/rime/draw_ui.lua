---draw UI
---@param context table
---@param ui table
---@param left_width integer
---@return string[]
---@return integer
return function(context, ui, left_width)
    local preedit = context.composition.preedit or ""
    preedit = preedit:sub(1, context.composition.cursor_pos) ..
        ui.cursor .. preedit:sub(context.composition.cursor_pos + 1)
    local candidates = context.menu.candidates
    local candidates_ = ""
    local indices = ui.indices
    for index, candidate in ipairs(candidates) do
        local text = indices[index] .. " " .. candidate.text
        if candidate.comment ~= nil then
            text = text .. " " .. candidate.comment
        end
        if (context.menu.highlighted_candidate_index + 1 == index) then
            text = ui.left_sep .. text
        elseif (context.menu.highlighted_candidate_index + 2 == index) then
            text = ui.right_sep .. text
        else
            text = " " .. text
        end
        candidates_ = candidates_ .. text
    end
    if (context.menu.num_candidates == context.menu.highlighted_candidate_index + 1) then
        candidates_ = candidates_ .. ui.right_sep
    else
        candidates_ = candidates_ .. " "
    end
    local col = 0
    local left = ui.left
    if context.menu.page_no ~= 0 then
        local num = left_width
        candidates_ = left .. candidates_
        local whitespace = " "
        preedit = whitespace:rep(num) .. preedit
        col = col - num
    end
    if (context.menu.is_last_page == false and context.menu.num_candidates > 0) then
        candidates_ = candidates_ .. ui.right
    end
    return { preedit, candidates_ }, col
end
