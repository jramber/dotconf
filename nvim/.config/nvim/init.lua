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

vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.foldmethod = "indent"
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
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
vim.opt.cursorline = true
vim.opt.mouse="a"
vim.opt.termguicolors = true -- Enable 24bits color
vim.opt.autoread = true --  Auto update the file if changed externally
vim.opt.lazyredraw = true -- faster scroll
-- vim.opt.showmode = false
-- vim.opt.winborder = "single"

vim.pack.add {
    -- navigation
    'https://github.com/nvim-lua/plenary.nvim', -- dep
    { src = 'https://github.com/theprimeagen/harpoon', version = 'harpoon2'},

    -- treesitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main'},
    -- lsp
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    -- { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- { src = "https://github.com/mason-org/mason.nvim" },
    -- { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- completion
    { src = 'https://github.com/rafamadriz/friendly-snippets' }, -- dependency
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/saghen/blink.cmp' },
    -- 'https://github.com/folke/which-key.nvim',
    { src = 'https://github.com/windwp/nvim-autopairs' },
    -- TODO: could be simplified
    -- tmux
    { src ='https://github.com/christoomey/vim-tmux-navigator'},
    -- telescope
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', version = 'main' }, -- dependency
    'https://github.com/nvim-telescope/telescope.nvim',
    -- Themes
    { src = 'https://github.com/navarasu/onedark.nvim' },
    { src = 'https://github.com/rktjmp/lush.nvim' }, -- dep
    { src = 'https://github.com/zenbones-theme/zenbones.nvim' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/loctvl842/monokai-pro.nvim' },
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/projekt0n/github-nvim-theme' },
    -- Git
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/kdheepak/lazygit.nvim' },
    -- Docker
    -- 'https://github.com/jesseduffield/lazydocker'
    -- Quickfix
    { src = 'https://github.com/stevearc/quicker.nvim'},
}

require'quicker'.setup {}

-- TODO: organice setup

-- navigation
-- treesitter
-- ...
-- completion
require'nvim-autopairs'.setup {}

require'gitsigns'.setup {
    current_line_blame = true,
}

require'nvim-treesitter'.setup {
    auto_install = true,
    sync_install = false,
    indent = {
        enable = true,
    },
}
require'nvim-treesitter'.install {
    -- web
    'javascript',
    'typescript',
    'tsx',
    'html',
    'css',
    'json',
    -- 
    'markdown',
    'rust',
    'c',
    'cpp',
    'python',
    'lua',
    'luadoc',
    'vim',
    'vimdoc',
}


-- require("mason").setup()
-- require("mason-lspconfig").setup({})
-- require("mason-tool-installer").setup({
--   ensure_installed = {
--     "lua_ls",
--   },
--   auto_update = false,
--   run_on_start = true,
-- })

vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    root_markers = { '.git' }
})
vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' }, -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
            globals = { 'vim', 'require' }
        }
      }
    }
}

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
local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end
end
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      local params = {
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      }
      client.request('workspace/executeCommand', params, nil, bufnr)
    end, {
      desc = 'Organize Imports',
    })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
      desc = 'Reconfigure pyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
  end,
})
local function reload_workspace(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
  for _, client in ipairs(clients) do
    vim.notify 'Reloading Cargo Workspace'
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request('rust-analyzer/reloadWorkspace', nil, function(err)
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
vim.lsp.config('rust-analyzer', {
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
})
vim.lsp.enable({'luals', 'ts_ls', 'marksman', 'pyright', 'rust_analyzer'})

require("luasnip.loaders.from_vscode").lazy_load()
require'blink.cmp'.setup {
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = {
        auto_show = true,
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
}

local function build_fzf_native()
    local fzf_native_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
    if vim.fn.isdirectory(fzf_native_path) == 1 and vim.fn.filereadable(fzf_native_path .. "/build/libfzf.so") == 0 then
        vim.system({ "make" }, { cwd = fzf_native_path })
    end
end
build_fzf_native()
require'telescope'.setup {
    defaults = {
        border = false,
    },
    build_step = function()
    end,
    pickers = {
        find_files = {
            theme = "ivy",
            border = false
        }
    },
    extensions = {
        fzf = {}
    }
}
require'telescope'.load_extension('fzf')
local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local make_entry = require'telescope.make_entry'
local conf = require'telescope.config'.values
local git_command = require'telescope.utils'.__git_command
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

-- TODO: review keymaps
-- LspAttach keymaps
vim.api.nvim_create_autocmd(
  "LspAttach",
  { --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

      -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float({
          border = "rounded",
        })
      end, opts)
    end,
  }
)

local map = vim.keymap.set
local harpoon = require'harpoon'
map("n", "<C-h>", function() harpoon:list():select(1) end)
map("n", "<C-t>", function() harpoon:list():select(2) end)
map("n", "<C-n>", function() harpoon:list():select(3) end)
map("n", "<C-s>", function() harpoon:list():select(4) end)
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
map("n", "<leader>a", function() harpoon:list():add() end)
map("n", "<leader>A", function() harpoon:list():prepend() end)
map('n', '<leader>ff', require'telescope.builtin'.find_files, { desc = 'Telescope find files' })
map("n", "<leader>fg", function() live_multigrep(require'telescope.themes'.get_ivy { border = false }) end)
map({ 'n', 'v' }, "<leader>tg", require'telescope.builtin'.grep_string)
-- quickfix and location list naviagtion
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")
-- Source nvim config changes
map("n", "<leader>so", ":update<CR> :source<CR>")
-- Save and quit current file quicker
map("n", "<leader>w", ":w<cr>", { silent = false, noremap = true })
map({ "n", "t" }, "<leader>q", ":q<cr>", { silent = false, noremap = true })
-- Yank to system clipboard
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
-- Open buffer to the right
map("n", "<leader>v", ":vsplit<CR>")
-- Move selection up and down
map("v", "<C-Down>", ":m '>+1<CR>gv=gv")
map("v", "<C-Up>", ":m '<-2<CR>gv=gv")

map('n', '<leader>qs', '<cmd>:lua vim.lsp.buf.document_symbol({ loclist = false })<CR>', { noremap = true, silent = true })

vim.cmd("set completeopt+=noselect")

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client ~= nil and client:supports_method("textDocument/completion") then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

-- Highlight yank
vim.api.nvim_create_autocmd("textyankpost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})
-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- Found a supporting client, no need to check others
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

function SetColorScheme()
    -- vim.cmd.colorscheme  '...'
    local color_scheme = 'tokyonight'
    vim.cmd('colorscheme '  .. color_scheme)
end
-- vim.api.nvim_create_user_command('SetColorScheme', SetColorScheme, {})
--
SetColorScheme()
