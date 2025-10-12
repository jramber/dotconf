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
    "https://github.com/christoomey/vim-tmux-navigator", -- dep
    "https://github.com/nvim-lualine/lualine.nvim",
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", version = "main" }, -- dep
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

-- TODO: this funtion can be move inside
local function build_fzf_native()
    local fzf_native_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
    if vim.fn.isdirectory(fzf_native_path) == 1 and vim.fn.filereadable(fzf_native_path .. "/build/libfzf.so") == 0 then
        vim.system({ "make" }, { cwd = fzf_native_path })
    end
end
build_fzf_native()
require("telescope").setup({
    build_step = function()
    end,
    pickers = {
        find_files = {
            theme = "ivy"
        }
    },
    extensions = {
        fzf = {}
    }
})
require('telescope').load_extension('fzf')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local git_command = require "telescope.utils".__git_command
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

require('harpoon').setup({
    menu = {
        width = vim.api.nvim_win_get_width(0)- 4,
    }
})

require("blink.cmp").setup({
    keymap = { preset = 'default' },
    appearence = {
        use_nvim_cmp_as_default = true,
    },
    completion = {
        -- accept = { auto_brackets = { enabled = false }},
        -- documentation = { enabled = true },
        -- ghost_text = { enabled = true },
        signature = {
            enabled = true,
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("github-theme").setup({})
vim.cmd('colorscheme github_light_default')

local map = vim.keymap.set
local harpoon = require("harpoon")

map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

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
map('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git files' })
map("n", "<leader>fg", function()
    local opts = require("telescope.themes").get_ivy({})
    live_multigrep(opts)
end)
map({ 'n', 'v' }, "<leader>tg", require("telescope.builtin").grep_string)
map('n', "<C-p>", function()
    local opts = require("telescope.themes").get_dropdown({})
    git_diff_grep(opts)
end)

vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    root_markers = { '.git' }
})

vim.lsp.config['luals'] = {
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
-- check https://github.com/neovim/nvim-lspconfig/blob/master/lsp/biome.lua#L12 for more information
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
}
vim.lsp.config['marksman'] = {
    cmd = { "marksman" },
    filetypes = { "markdown", "markdown.mdx" },
    root_makers = { ".marksman.toml", ".git" }
}

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

vim.lsp.config['ts_ls'] = {
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
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
  handlers = {
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
}

vim.lsp.enable({'luals', 'ts_ls'})

