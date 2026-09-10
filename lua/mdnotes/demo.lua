---@module 'mdnotes.demo'
---
local M = {}

-- TODO: Maybe add progress message?
-- Maybe put this in a demo.lua because it will be massive. function will be run()
-- Place GIF in readme and then say below: This was a recording of the :Mdn miscellaneous run_demo command.
-- If testing in CI, set delays to 0 or 1 and test that the function finishes correctly

local demo_running = false
local demo_buf = 0
local demo_win = 0

local function stop_demo()
    demo_running = false
    vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        "# Mdnotes Demo",
        "(Press <ESC> to stop demo)",
    })
    vim.cmd.write()
    vim.cmd("bw! " .. demo_buf)
    vim.notify("Mdn: Demo stopped")
end

-- Demo runner
local function run_demo(steps)
    local co

    local function pause(ms)
        vim.defer_fn(function()
            if coroutine.status(co) == "suspended" then
                coroutine.resume(co)
            end
        end, ms)

        coroutine.yield()
    end

    co = coroutine.create(function()
        for _, step in ipairs(steps) do
            step.action()
            pause(step.delay or 1000)

            if demo_running == false then
                coroutine.yield()
            end
        end
    end)

    coroutine.resume(co)
end

---Run demo (AI assisted)
function M.run()
    local demo_path = vim.fs.joinpath(require('mdnotes').plugin_install_dir, "tests/markdown-test-files/demo-files/demo.md")
    demo_buf = vim.fn.bufadd(demo_path)
    vim.bo[demo_buf].filetype = "markdown"

    vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        "# Mdnotes Demo",
        "(Press <ESC> to stop demo)",
    })

    demo_running = true
    vim.keymap.set("n", "<Esc>", stop_demo, { buffer = demo_buf, })
    demo_win = vim.api.nvim_open_win(demo_buf, true, {relative='win', row=1, col=3, width=150, height=40})

    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    local ctrl_u = vim.api.nvim_replace_termcodes("<C-U>", true, false, true)

    run_demo({
        -- {
        --     action = function()
        --         -- initial delay
        --     end,
        --     delay = 1000,
        -- },
        -- -- Formatting Demo Start
        -- {
        --     action = function()
        --         vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        --             "# Mdnotes Demo",
        --             "(Press <ESC> to stop demo)",
        --             "",
        --             "## Formatting",
        --             "Set formatting:",
        --             "- Emphasis",
        --             "- Strong",
        --             "- Strikethrough",
        --             "- Autolinks https://neovim.io/",
        --             "- Inline code",
        --         })
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(6, 3)
        --         vim.api.nvim_feedkeys(":Mdn formatting emphasis_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(7, 3)
        --         vim.api.nvim_feedkeys(":Mdn formatting strong_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(8, 3)
        --         vim.api.nvim_feedkeys(":Mdn formatting strikethrough_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(9, 13)
        --         vim.api.nvim_feedkeys("v$", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn formatting autolink_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(10, 3)
        --         vim.api.nvim_feedkeys("v$", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn formatting inline_code_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        --             "# Mdnotes Demo",
        --             "(Press <ESC> to stop demo)",
        --             "",
        --             "## Formatting",
        --             "Toggle fenced code blocks:",
        --             "// fenced",
        --             "// code block",
        --             "// example",
        --         })
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(6, 1)
        --         vim.api.nvim_feedkeys("Vjjj", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn formatting fenced_code_block_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn formatting fenced_code_block_toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        --             "# Mdnotes Demo",
        --             "(Press <ESC> to stop demo)",
        --             "",
        --             "## Formatting",
        --             "Automatically continue unordered lists:",
        --             "- Item 1",
        --             "- Item 2",
        --         })
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(7, 1)
        --         require('mdnotes').new_line_remap('o')
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys("Item 3", "n", false)
        --         vim.api.nvim_feedkeys(esc, "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        --             "# Mdnotes Demo",
        --             "(Press <ESC> to stop demo)",
        --             "",
        --             "## Formatting",
        --             "Automatically continue ordered lists, and renumber:",
        --             "1. Item 1",
        --             "3. Item 2",
        --         })
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(7, 1)
        --         require('mdnotes').new_line_remap('o')
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys("Item 3", "n", false)
        --         vim.api.nvim_feedkeys(esc, "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn formatting ordered_list_renumber\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- Formatting Demo End
        -- Inline Link Demo Start
        -- {
        --     action = function()
        --         vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
        --             "# Mdnotes Demo",
        --             "(Press <ESC> to stop demo)",
        --             "",
        --             "## Inline links",
        --             "- Open [link.md](link.md#fragment)",
        --             "- Toggle [link](https://neovim.io/)",
        --             "- Rename [link](https://neovim.io/)",
        --             "- Relink [link](https://neovim.io/)",
        --             "- Normalize [path](a/../path/to/../normalize)",
        --         })
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(5, 8)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link open\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         require('mdnotes.history').go_back()
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(6, 11)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(6, 10)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link toggle\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(7, 11)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link rename\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(ctrl_u, "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys("renamed\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(8, 11)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link relink\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(ctrl_u, "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys("https://www.example.com/\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.fn.cursor(9, 14)
        --     end,
        --     delay = 1000,
        -- },
        -- {
        --     action = function()
        --         vim.api.nvim_feedkeys(":Mdn inline_link normalize\n", "n", false)
        --     end,
        --     delay = 1000,
        -- },
        -- Inline Link Demo End
        -- WikiLink Demo Start
        {
            action = function()
                vim.api.nvim_buf_set_lines(demo_buf, 0, -1, false, {
                    "# Mdnotes Demo",
                    "(Press <ESC> to stop demo)",
                    "",
                    "## WikiLinks",
                    "- Create WikiLink",
                    "- Follow [[WikiLink]]",
                    "- Delete [[WikiLink]]",
                    "- Find references to [[WikiLink]]",
                    "- Rename references to [[WikiLink]]",
                    "- Undo the rename",
                })
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.fn.cursor(5, 10)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.api.nvim_feedkeys(":Mdn wikilink create\n", "n", false)
                vim.cmd.write()
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.fn.cursor(6, 10)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.api.nvim_feedkeys(":Mdn wikilink follow\n", "n", false)
            end,
            delay = 1000,
        },
        {
            action = function()
                local buf = vim.api.nvim_get_current_buf()
                require('mdnotes.history').go_back()
                vim.cmd("bw! " .. buf)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.fn.cursor(7, 10)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.api.nvim_feedkeys(":Mdn wikilink delete", "n", false)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.api.nvim_feedkeys("\ny\n", "n", false)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.cmd([[undo]])
                local cwd = require('mdnotes').cwd
                vim.uv.fs_copyfile(vim.fs.joinpath(cwd, "WikiLink-backup.md"), vim.fs.joinpath(cwd, "WikiLink.md"))
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.fn.cursor(8, 22)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.api.nvim_feedkeys(":Mdn wikilink find_references\n", "n", false)
            end,
            delay = 1000,
        },
        {
            action = function()
                vim.cmd([[ccl]])
                vim.api.nvim_set_current_win(demo_win)
            end,
            delay = 1000,
        },
    })
end

return M
