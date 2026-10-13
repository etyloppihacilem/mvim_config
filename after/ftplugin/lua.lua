-- Do not insert the comment leader after hitting o, O or <Enter>
vim.opt_local.formatoptions:remove { "o", "r" }

vim.keymap.set("n", "<F9>", "<cmd>luafile %<CR>", { buffer = true, silent = true, desc = "run lua file" })

-- For delimitMate
vim.b.delimitMate_matchpairs = "(:),[:],{:}"
