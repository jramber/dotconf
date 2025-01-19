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
              'eslint',
              'ts_ls',
              'rust_analyzer',
              'lua_ls',
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
          }
      })
  end,
}

