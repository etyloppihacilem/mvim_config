-- Personal clangd settings, merged on top of nvim-lspconfig's defaults.
---@type vim.lsp.Config
return {
  cmd = require("config.clangd").cmd(),
}
