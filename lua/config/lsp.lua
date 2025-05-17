local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

require("mason-lspconfig").setup {
    automatic_enable = true,
}

diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [diagnostic.severity.ERROR] = "",
      [diagnostic.severity.WARN]  = "",
      [diagnostic.severity.INFO]  = "",
      [diagnostic.severity.HINT]  = "",
    },
    texthl = {
      [diagnostic.severity.ERROR] = "DiagnosticSignError",
      [diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [diagnostic.severity.INFO]  = "DiagnosticSignInfo",
      [diagnostic.severity.HINT]  = "DiagnosticSignHint",
    },
  },
  float = {
    border = "rounded",
    source = "always",
  },
})

api.nvim_create_autocmd("CursorHold", {
  callback = function()
    diagnostic.open_float(nil, {
      focusable = false,
      border = "rounded",
      source = "always",
      prefix = "",
      scope = "line", -- ou "cursor"
    })
  end,
})

