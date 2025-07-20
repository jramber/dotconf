vim.lsp.config['biome'] = {
    cmd = { 'biome' },
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
    root_markers = {{'biome.json', 'biome.jsonc'}, '.git' }
}
