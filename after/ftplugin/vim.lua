-- Do not insert the comment leader after hitting o, O or <Enter>
vim.opt_local.formatoptions:remove { "o", "r" }

-- Fold on `"{` markers, see autoload/utils.vim
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "utils#VimFolds(v:lnum)"
vim.wo.foldtext = "utils#MyFoldText()"

-- Use :help for the keyword under cursor when pressing K
vim.bo.keywordprg = ":help"

vim.keymap.set("n", "<F9>", "<cmd>source %<CR>", { buffer = true, silent = true, desc = "source vim file" })
