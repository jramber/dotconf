return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    opts = {
        animate = {
            enabled = false,
        },
        bottom = {
            { ft = "qf", title = "QuickFix" },
            {
                ft = "help",
                size = { height = 20 },
                -- only show help buffers
                filter = function(buf)
                    return vim.bo[buf].buftype == "help"
                end,
            },
        },
        right = {
            {
                -- @TODO: further filter to distinguish between LSP and diagnostics
                ft = "trouble",
                size = { width = 40 },
            },
        }
    },
}
