if vim.fn.exists(":AsyncRun") == 2 then
  vim.keymap.set(
    "n",
    "<F9>",
    '<cmd>AsyncRun python -u "%"<CR>',
    { buffer = true, silent = true, desc = "run python file" }
  )
end

vim.wo.wrap = true
vim.wo.colorcolumn = "120"

vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

-- For delimitMate
vim.b.delimitMate_matchpairs = "(:),[:],{:}"
