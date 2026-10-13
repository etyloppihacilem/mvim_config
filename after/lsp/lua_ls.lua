-- lua_ls settings, merged on top of nvim-lspconfig's defaults.
-- The Neovim runtime and plugin types are provided by lazydev.nvim (see lua/plugins/lsp.lua).
---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
    },
  },
}
