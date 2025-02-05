local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local git_command = require "telescope.utils".__git_command

local M = {}

local live_multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "rg" }

            if pieces[1] then
                table.insert(args, "-e")
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, "-g")
                table.insert(args, pieces[2])
            end

            return vim.tbl_flatten {
                args,
                { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
            }
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }

    pickers.new(opts, {
        debounce = 100,
        prompt_title = "Multi Grep",
        finder = finder,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
    }):find()
end

local git_diff_grep = function(opts)
    opts         = opts or {}
    opts.cwd     = opts.cwd or vim.uv.cwd()

    local output = vim.fn.systemlist("git status --porcelain")
    local files  = {}

    for _, line in ipairs(output) do
        table.insert(files, line:sub(4)) -- Remove the first three characters
    end

    pickers.new(opts, {
        prompt_title = "Git Files",
        __locations_input = true,
        finder = finders.new_table({
            results = files
        }),
        previewer = conf.grep_previewer(opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

M.setup = function()
    vim.keymap.set("n", "<leader>fg", live_multigrep)
    vim.keymap.set({ 'n', 'v' }, "<leader>tg", require("telescope.builtin").grep_string)

    vim.keymap.set('n', "<C-p>", function()
        local opts = require("telescope.themes").get_dropdown({})
        git_diff_grep(opts)
    end)
end

return M
