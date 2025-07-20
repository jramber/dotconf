vim.lsp.config['rust_analyzer'] = {
    cmd = { "rust-analyzer" },
    filetypes = { 'rust', 'rs' }
    root_markers = { 'Cargo.toml', '.git' }
}
