-- Fold with tree-sitter, all folds closed initially
vim.wo.foldlevel = 0
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
