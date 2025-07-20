-- TODO: add capabilities to the rest of lsp

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
-- ...

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main"},
    "https://github.com/rafamadriz/friendly-snippets", -- dep
    "https://github.com/saghen/blink.cmp",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/f-person/git-blame.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    "https://github.com/nvim-lualine/lualine.nvim",
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", version = "main" },
    "https://github.com/nvim-telescope/telescope.nvim",
    { src = "https://github.com/theprimeagen/harpoon", version = "harpoon2"},
    "https://github.com/projekt0n/github-nvim-theme", -- theme
})

require('nvim-treesitter').setup {}
require('nvim-treesitter').install({ "rust", "javascript", "typescript", "c", "lua", "vimdoc" })
require("nvim-autopairs").setup({ event = "InsertEenter" })
require("gitblame").setup {
    enabled = 0,
    message_template = "<date> - <author> - <summary> - <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 0,
    display_virtual_text = 1,
}
require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = 'onelight',
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
})
require("telescope").setup({
    extensions = {
        -- fzf = {}
    }
})
-- require('telescope').load_extension('fzf')
-- require "config.telescope.multigrep".setup()
require('harpoon').setup({
    menu = {
        width = vim.api.nvim_win_get_width(0)- 4,
    }
})
require("blink.cmp").setup({
    -- fuzzy = { implementation = "prefer_rust_with_warning" }
    appearence = {
        use_nvim_cmp_as_default = true,
    },
    completion = {
        ghost_text = { enabled = true },
        accept = { auto_brackets = { enabled = true }},
        signature = { enabled = true},
    }
})

require("github-theme").setup({})
vim.cmd('colorscheme github_light_default')

local map = vim.keymap.set
local harpoon = require("harpoon")
local builtin = require('telescope.builtin')
map("n", "<leader>fs", "<cmd>Ex<CR>", { noremap = true, silent = true })
map("n", "<M-j>", "<cmd>cnext<CR>") -- next quickfix item
map("n", "<M-k>", "<cmd>cprev<CR>") -- previous quickfix item
map("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { noremap = true, silent = true }) -- git-blame
map("n", "<leader>?", function() require("which-key").show({ global = false }) end)
map("n", "<C-h>", function() harpoon:list():select(1) end)
map("n", "<C-t>", function() harpoon:list():select(2) end)
map("n", "<C-n>", function() harpoon:list():select(3) end)
map("n", "<C-s>", function() harpoon:list():select(4) end)
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
map("n", "<leader>a", function() harpoon:list():add() end)
map("n", "<leader>A", function() harpoon:list():prepend() end)
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })

local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config['luals'] = {
    capabilities = capabilities,
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
            globals = { 'vim' }
        }
      }
    }
}
local util = require('lspconfig.util')
-- check https://github.com/neovim/nvim-lspconfig/blob/master/lsp/biome.lua#L12 for more informatoin
vim.lsp.config['biome'] = {
    cmd = function(dispatchers, config)
      local cmd = 'biome'
      local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'
      if local_cmd and vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
      return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
    end,
    filetypes = {
      'astro',
      'css',
      'graphql',
      'html',
      'javascript',
      'javascriptreact',
      'json',
      'jsonc',
      'svelte',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'vue',
    },
    workspace_required = true,
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local root_files = { 'biome.json', 'biome.jsonc' }
      root_files = util.insert_package_json(root_files, 'biome', fname)
      local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
      on_dir(root_dir)
    end,
    capabilities = capabilities
}
-- vim.lsp.config['marksman'] = {
--     cmd = { "marksman" },
--     filetypes = { "markdown", "markdown.mdx" },
--     root_makers = { ".marksman.toml", ".git" }
-- }
local function reload_workspace(bufnr)
    local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
    for _, client in ipairs(clients) do
      vim.notify 'Reloading Cargo Workspace'
      client.request('rust-analyzer/reloadWorkspace', nil, function(err)
        if err then
          error(tostring(err))
        end
        vim.notify 'Cargo workspace reloaded'
      end, 0)
    end
end
local function is_library(fname)
    local user_home = vim.fs.normalize(vim.env.HOME)
    local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
    local registry = cargo_home .. '/registry/src'
    local git_registry = cargo_home .. '/git/checkouts'
    
    local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
    local toolchains = rustup_home .. '/toolchains'
    
    for _, item in ipairs { toolchains, registry, git_registry } do
      if vim.fs.relpath(item, fname) then
        local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
        return #clients > 0 and clients[#clients].config.root_dir or nil
      end
    end
end
vim.lsp.config['rust-analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    capabilities = capabilities,
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local reused_dir = is_library(fname)
      if reused_dir then
        on_dir(reused_dir)
        return
      end

      local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
      local cargo_workspace_root

      if cargo_crate_dir == nil then
        on_dir(
          vim.fs.root(fname, { 'rust-project.json' })
            or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
        )
        return
      end

      local cmd = {
        'cargo',
        'metadata',
        '--no-deps',
        '--format-version',
        '1',
        '--manifest-path',
        cargo_crate_dir .. '/Cargo.toml',
      }

      vim.system(cmd, { text = true }, function(output)
        if output.code == 0 then
          if output.stdout then
            local result = vim.json.decode(output.stdout)
            if result['workspace_root'] then
              cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
            end
          end

          on_dir(cargo_workspace_root or cargo_crate_dir)
        else
          vim.schedule(function()
            vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
          end)
        end
      end)
    end,
    capabilities = {
      experimental = {
        serverStatusNotification = true,
      },
    },
    before_init = function(init_params, config)
      -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
      if config.settings and config.settings['rust-analyzer'] then
        init_params.initializationOptions = config.settings['rust-analyzer']
      end
    end,
    on_attach = function(_, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
        reload_workspace(bufnr)
      end, { desc = 'Reload current cargo workspace' })
    end,
}
vim.lsp.enable({'luals', 'biome', 'rust-analyzer'})

