return {
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("catppuccin").setup({
    --             -- flavour = "latte",
    --             flavour = "mocha",
    --             transparent_background = true

    --         })
    --         vim.cmd([[colorscheme catppuccin]])
    --         -- vim.cmd("colorscheme catppuccin")
    --     end
    -- },

    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })

            vim.cmd('colorscheme github_light')
        end,
    }
}
