-- Neovim configuration entry point.
--
-- Originally forked from https://github.com/jdhao/nvim-config, now maintained by hmelica.
-- Targets the latest Neovim stable release (0.12+).
--
-- Layout:
--   lua/core/      editor settings that do not depend on plugins (options, keymaps, autocmds, LSP, lazy.nvim)
--   lua/plugins/   lazy.nvim plugin specs, one file per theme
--   lua/config/    bigger plugin configurations required from the specs
--   after/lsp/     native LSP server settings, merged over nvim-lspconfig (see `:h lsp-config`)
vim.loader.enable()

local config_dir = vim.fn.stdpath("config")

-- Optional local tool directories: a Python venv living next to the config (see requirements.txt)
-- and a user-installed Node.js. They are only added to PATH when they exist.
local extra_paths = {
  config_dir .. "/venv_nvim/bin",
  vim.fn.expand("~/tools/node-v14.15.4-linux-x64/bin"),
}
for _, dir in ipairs(extra_paths) do
  if vim.fn.isdirectory(dir) == 1 then
    vim.env.PATH = dir .. ":" .. vim.env.PATH
  end
end

require("core.globals") -- global variables, leader key, disabled builtin plugins
require("core.options") -- editor options
require("core.filetypes") -- custom filetype detection
require("core.autocmds") -- autocommands
require("core.keymaps") -- plugin-independent mappings
require("core.lsp") -- native LSP setup (diagnostics, keymaps on attach, enabled servers)
require("core.lazy") -- plugin manager and plugins

require("config.colorschemes").load("edge")
