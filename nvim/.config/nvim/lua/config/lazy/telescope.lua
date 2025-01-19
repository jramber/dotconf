return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
        require('telescope').setup({
            extensions = {
                fzf = {}
            },
        })

        require('telescope').load_extension('fzf')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git files' })

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ")});
        end)

        require "config.telescope.multigrep".setup()
    end
}
