local utils = require("utils")

-- Inspect something (`:lua inspect(x)`)
function _G.inspect(item)
  vim.print(item)
end

------------------------------------------------------------------------
--                          custom variables                          --
------------------------------------------------------------------------
vim.g.is_win = utils.has("win32") or utils.has("win64")
vim.g.is_linux = utils.has("unix") and not utils.has("macunix")
vim.g.is_mac = utils.has("macunix")

vim.g.logging_level = "info"

-- Snippets written for LuaSnip
vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/my_snippets"

------------------------------------------------------------------------
--                         builtin variables                          --
------------------------------------------------------------------------
-- Leader must be set before any mapping (and before lazy.nvim) is defined.
vim.g.mapleader = ","

vim.g.loaded_perl_provider = 0 -- Disable perl provider
vim.g.loaded_ruby_provider = 0 -- Disable ruby provider
vim.g.loaded_node_provider = 0 -- Disable node provider
vim.g.did_install_default_menus = 1 -- do not load menu

if utils.executable("python3") then
  if vim.g.is_win then
    vim.g.python3_host_prog = vim.fn.substitute(vim.fn.exepath("python3"), ".exe$", "", "g")
  else
    vim.g.python3_host_prog = vim.fn.exepath("python3")
  end
else
  vim.notify("Python3 executable not found, the python provider is disabled.", vim.log.levels.WARN)
  vim.g.loaded_python3_provider = 0
end

-- Enable highlighting for lua HERE doc inside vim script
vim.g.vimsyn_embed = "l"

-- Use English as main language (the locale may not exist on every machine)
pcall(vim.cmd.language, "en_US.UTF-8")

-- Do not load netrw, nvim-tree is used instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Do not load tohtml and the tutor plugin
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Disable sql omni completion, it is broken.
vim.g.loaded_sql_completion = 1
