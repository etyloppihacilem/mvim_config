-- LSP servers, tools installation and formatting.
-- The LSP setup itself (keymaps, diagnostics, enabled servers) is native and lives in lua/core/lsp.lua.
return {
  -- Default server configurations (`lsp/<server>.lua` files), used by `vim.lsp.enable()`
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- Capabilities shared by every server (completion from nvim-cmp)
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
    end,
  },

  -- Installer for language servers, formatters and linters (`:Mason`)
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- Installs the servers below and calls `vim.lsp.enable()` for every server installed with Mason
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "arduino_language_server",
        "asm_lsp",
        "cmake",
        "cssls",
        "lua_ls",
        "ruff",
        "rust_analyzer",
      },
      automatic_enable = true,
    },
  },

  -- Formatters and other non-LSP tools installed with Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "stylua" },
    },
  },

  -- Neovim runtime and plugin types for lua_ls when editing this config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- LSP progress messages
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Formatting (<C-e> in normal mode, see lua/core/keymaps.lua)
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        tex = { "latexindent" },
        sh = { "beautysh" },
        html = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
      },
      formatters = {
        latexindent = {
          -- -l: look for localsettings.yaml, -m: modify, -: read from stdin
          args = { "-l", "-m", "-" },
        },
      },
    },
  },
}
