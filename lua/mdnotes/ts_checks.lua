---@module 'mdnotes.ts_checks'

local M = {}

---@param node TSNode?
---@param type_tbl table<string> Which type to check the node is
local function check(node, type_tbl)
    if node == nil then return nil end
    local ntype = node:type()
    if vim.tbl_contains(type_tbl, ntype) then
        local row_start, col_start, _, col_end = node:range()
        return {
            cols = {col_start + 1, col_end + 1},
            lnum = row_start + 1,
        }
    else
        return nil
    end
end

---@class MdnTSNodeType
---@field wikilink fun(node: TSNode): table?
---@field inline_link fun(node: TSNode): table?
---@field strong fun(node: TSNode): table?
---@field emphasis fun(node: TSNode): table?
---@field strikethrough fun(node: TSNode): table?
---@field inline_code fun(node: TSNode): table?
---@field autolink fun(node: TSNode): table?
---@field reference_link fun(node: TSNode): table?
---@field footnote_reference fun(node: TSNode): table?
M = {
    wikilink = function(node)
        return check(node, {"shortcut_link"})
    end,
    inline_link = function(node)
        return check(node, {"inline_link", "image"})
    end,
    strong = function(node)
        return check(node, {"strong_emphasis"})
    end,
    emphasis = function(node)
        return check(node, {"emphasis"})
    end,
    strikethrough = function(node)
        return check(node, {"strikethrough"})
    end,
    inline_code = function(node)
        return check(node, {"code_span"})
    end,
    autolink = function(node)
        return check(node, {"uri_autolink"})
    end,
    reference_link = function(node)
        return check(node, {"collapsed_reference_link", "full_reference_link"})
    end,
    footnote_reference = function(node)
        return check(node, {"shortcut_link"})
    end,
}

return M
