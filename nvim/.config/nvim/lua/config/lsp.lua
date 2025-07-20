-- lsp
--------------------------------------------------------------------------------
--  See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
--  of how the lsp setup works for neovim 0.11+

--  This actually just enables the lsp servers.
--  The configuration is found in the lsp folder inside the nvim config folder,
--  so in ~/.config/nvim/lsp/lua_ls.lua for lua_ls for example

vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.enable({'luals', 'biome', 'marksman', 'rust_analyzer'})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- Unset 'formatexpr'
    vim.bo[args.buf].formatexpr = nil
    -- Unset 'omnifunc'
    vim.bo[args.buf].omnifunc = nil
    -- Unmap K
    vim.keymap.del('n', 'K', { buffer = args.buf })
  end,
})

