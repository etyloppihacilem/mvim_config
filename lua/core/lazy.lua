-- Bootstrap lazy.nvim and load every spec in lua/plugins/.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = { { import = "plugins" } },
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  change_detection = { notify = false },
  rocks = { enabled = false }, -- no plugin needs luarocks
}

-- Short aliases for lazy commands: type `:pi<space>` to get `:Lazy install`, etc.
vim.fn["utils#Cabbrev"]("pi", "Lazy install")
vim.fn["utils#Cabbrev"]("pud", "Lazy update")
vim.fn["utils#Cabbrev"]("pc", "Lazy clean")
vim.fn["utils#Cabbrev"]("ps", "Lazy sync")
