return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local git_blame = require('gitblame');
        require('lualine').setup {
            options = {
                icons_enabled = false,
                theme = 'catppuccin',
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
                component_separators = { left = '│', right = '│' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                -- lualine_c = { { 'filename', path = 1 } },
                lualine_c = {
                    { 'filename',                       path = 1,                                cond = function() return not
                        git_blame.is_blame_text_available() end },
                    { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
                },
                -- git_blame
                -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
                -- lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }, 'filetype' },
                lualine_x = { 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    end
}
