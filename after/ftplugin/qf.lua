-- Quickfix window height between 5 and 15 lines, see also https://github.com/lervag/vimtex/issues/1127
local height = math.max(5, math.min(vim.fn.line("$"), 15))
vim.cmd.wincmd { args = { "_" }, count = height }
