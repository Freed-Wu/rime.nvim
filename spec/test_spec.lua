local parse_key = require "lua.rime.parse_key"

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests parse_key", function()
        assert.are.equal(parse_key("<C-S>", {}), parse_key("s", { "Control" }))
        assert.are.equal(parse_key("<M-C-S>", {}), parse_key("s", { "Control", "Alt" }))
    end)
end)
