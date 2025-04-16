return {
    'theprimeagen/harpoon',
    enabled = true,
    branch = "harpoon2",
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = function()
        local harpoon = require("harpoon")

        return {
            { "<C-h>",     function() harpoon:list():select(1) end,                     desc = "Harpoon file 1" },
            { "<C-t>",     function() harpoon:list():select(2) end,                     desc = "Harpoon file 2" },
            { "<C-n>",     function() harpoon:list():select(3) end,                     desc = "Harpoon file 3" },
            { "<C-s>",     function() harpoon:list():select(4) end,                     desc = "Harpoon file 4" },

            -- { "",  function() harpoon:list():next() end, desc = "Harpoon navigates to next buffer" }
            -- { "",  function() harpoon:list():prev() end, desc = "Harpoon navigates to previous buffer" }

            { "<C-e>",     function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
            { "<leader>A", function() harpoon:list():prepend() end,                     desc = "Harpoon prepend" },
            { "<leader>a", function() harpoon:list():add() end,                         desc = "Harpoon add" },

            -- { "<C-E>",     function() toggle_telescope(harpoon:list()) end,             desc = "" }
        }
    end,
    config = function()
        local harpoon = require("harpoon")
        harpoon.setup({
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
        })
    end
}
