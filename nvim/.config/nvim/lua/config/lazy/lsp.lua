return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "saghen/blink.cmp",
    },
    config = function()
        local DEFAULT_SETTINGS = {
            -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
            -- This setting has no relation with the `automatic_installation` setting.
            ---@type string[]
            ensure_installed = {
                --'eslint',
                --'ts_ls',
                'rust_analyzer',
                'lua_ls',
                'biome',
            },

            -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
            -- This setting has no relation with the `ensure_installed` setting.
            -- Can either be:
            --   - false: Servers are not automatically installed.
            --   - true: All servers set up via lspconfig are automatically installed.
            --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
            --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
            ---@type boolean
            automatic_installation = false,
        }

        local capabilities = require('blink.cmp').get_lsp_capabilities()
        -- capabilities.offsetEncoding = { "utf-16" }

        require("mason").setup({
            PATH = "prepend", -- "skip" seems to cause the spawning error
        })

        require("mason-lspconfig").setup({
            DEFAULT_SETTINGS,
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["biome"] = function()
                    local util = require("lspconfig").util
                    require("lspconfig").biome.setup {
                        cmd = { 'biome', 'lsp-proxy' },
                        filetypes = {
                            'astro',
                            'css',
                            'graphql',
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
                        root_dir = util.root_pattern('biome.json', 'biome.jsonc'),
                        single_file_support = false,
                        capabilities = capabilities,
                        settings = {
                            biome = {
                                formatter = { enabled = true },
                                linter = { enabled = true }
                            }
                        }
                    }
                end,
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup {
                        capabilities = capabilities,
                        single_file_support = true,
                        on_attach = function(client)
                            client.server_capabilities.documentFormattingProvider = false -- Disable formatting
                            client.server_capabilities.diagnosticProvider = false         -- Disable linting
                        end,
                    }
                end
            }
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                -- print(vim.inspect(args))
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end

                -- print(vim.inspect(client.server_capabilities))
                -- client.server_capabilities.documentFormattingProvider = true

                --@diagnostic disable-next-line: missing-parameter
                -- if client.supports_method('textDocument/formatting', 0) then
                -- Format the current buffer on save
                vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                    end,
                })
                --end
            end,
        })
    end,
}
