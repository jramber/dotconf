return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = 'main',
    build = ":TSUpdate",
    config = function()
        require 'nvim-treesitter'.setup {}
        require 'nvim-treesitter'.install({ "rust", "javascript", "typescript", "c", "lua", "vimdoc" })
    end
}
