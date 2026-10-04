---@module 'mdnotes.ts_checks'

local M = {}

local function check(node, type_tbl)
    if node == nil then return nil end
    local ntype = node:type()
    if vim.tbl_contains(type_tbl, ntype) then
        local _, col_start, _, col_end = node:range()
        return {col_start + 1, col_end + 1}
    else
        return nil
    end
end

---@class MdnTSNodeType
---@field inline_link fun(a ,b): any
---@field
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
