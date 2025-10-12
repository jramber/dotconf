--[[
    Juan David's minimal config
    ===========================

    design goals:
        - single file
        - use native nvim features
        - use default keybindings unless painful otherwise
        - use built-ins unless painful otherwise
        - plugins must be integral to workflow
]]

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
-- vim.opt.foldmethod = 'indent'
vim.opt.wrap = false
vim.opt.list = true --show trailing characters
vim.opt.listchars = { trail = "·", tab = "> ", space = "·"}
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80,120"
vim.opt.termguicolors = true
vim.opt.foldmethod = "indent"
vim.opt.winborder = "rounded"
vim.g.mapleader = " "

vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    { src = 'https://github.com/theprimeagen/harpoon', version = 'harpoon2'},
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main'},
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    'https://github.com/rafamadriz/friendly-snippets', -- dependency
    'https://github.com/saghen/blink.cmp',
    'https://github.com/windwp/nvim-autopairs',
    -- 'https://github.com/folke/which-key.nvim',
    'https://github.com/christoomey/vim-tmux-navigator',
    'https://github.com/f-person/git-blame.nvim',
    'https://github.com/nvim-lualine/lualine.nvim',

--   Themes
    'https://github.com/navarasu/onedark.nvim',
    'https://github.com/rktjmp/lush.nvim', -- dep
    'https://github.com/zenbones-theme/zenbones.nvim',
    'https://github.com/folke/tokyonight.nvim',
    'https://github.com/loctvl842/monokai-pro.nvim',
    'https://github.com/catppuccin/nvim',
}

require'nvim-treesitter'.setup {}
require'nvim-treesitter'.install { 'rust', 'javascript', 'typescript', 'c', 'lua', 'vimdoc' }

vim.lsp.config('ts_ls', {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
  handlers = {
    -- handle rename request for certain code actions like extracting functions / types
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  commands = {
    ['editor.action.showReferences'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local file_uri, position, references = unpack(command.arguments)

      local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
      vim.fn.setqflist({}, ' ', {
        title = command.title,
        items = quickfix_items,
        context = {
          command = command,
          bufnr = ctx.bufnr,
        },
      })

      vim.lsp.util.show_document({
        uri = file_uri,
        range = {
          start = position,
          ['end'] = position,
        },
      }, client.offset_encoding)

      vim.cmd('botright copen')
    end,
  },
  on_attach = function(client, bufnr)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
})
vim.lsp.enable({'ts_ls'})

require'gitblame'.setup {
    enabled = 0,
    message_template = "<date> - <author> - <summary> - <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 0,
    display_virtual_text = 1,
}

require'nvim-autopairs'.setup {}

require'blink.cmp'.setup {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },

    completion = { documentation = { auto_show = false } },
    signature = { enabled = true },
    -- fuzzy = { implementation = "prefer_rust_with_warning" }
}

require'lualine'.setup {
    options = {
        icons_enabled = false,
        theme = 'catppuccin-macchiato',
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
        lualine_c = { { 'filename', path = 1 } },
        -- lualine_c = {
        --     { 'filename', path = 1, cond = function()
        --         return not
        --             git_blame.is_blame_text_available()
        --     end },
        --     { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
        -- },
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

local map = vim.keymap.set
local harpoon = require'harpoon'
-- map("n", "<leader>cs", function() vim.cmd.colorscheme 'catppuccin-macchiato' end)
map("n", "<C-h>", function() harpoon:list():select(1) end)
map("n", "<C-t>", function() harpoon:list():select(2) end)
map("n", "<C-n>", function() harpoon:list():select(3) end)
map("n", "<C-s>", function() harpoon:list():select(4) end)
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
map("n", "<leader>a", function() harpoon:list():add() end)
map("n", "<leader>A", function() harpoon:list():prepend() end)
map("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { noremap = true, silent = true })

--[[
require('onedark').setup({
    style = 'dark'
})
]]

function SetColorScheme()
    local color_scheme = 'catppuccin-macchiato'
    -- vim.cmd.colorscheme  '...'
    vim.cmd('colorscheme '  .. color_scheme)
end

-- vim.api.nvim_create_user_command('SetColorScheme', SetColorScheme, {})

SetColorScheme()

