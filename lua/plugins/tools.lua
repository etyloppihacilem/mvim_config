-- Miscellaneous tools: tags, async jobs, debugger, sessions, browser integration...
local utils = require("utils")

return {
  -- Show file tags in a side window (requires ctags)
  {
    "liuchengxu/vista.vim",
    enabled = utils.executable("ctags"),
    cmd = "Vista",
    keys = { { "<Space>t", "<cmd>Vista!!<CR>", silent = true, desc = "toggle tag window" } },
    init = function()
      vim.g["vista#renderer#icons"] = { member = "" }
      -- Do not echo message on command line
      vim.g.vista_echo_cursor = 0
      -- Stay in current window when vista window is opened
      vim.g.vista_stay_on_open = 0
    end,
  },

  -- Asynchronous command execution
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
    init = function()
      -- Automatically open quickfix window of 6 line tall after asyncrun starts
      vim.g.asyncrun_open = 6
      if vim.g.is_win then
        vim.g.asyncrun_encs = "gbk"
      end
    end,
  },

  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = vim.g.is_win or vim.g.is_linux,
    build = "bash install.sh",
    cmd = { "GdbStart", "GdbStartLLDB", "GdbStartPDB", "GdbStartBashDB", "GdbStartRR" },
    keys = { { "<leader>dp", "<cmd>GdbStartPDB python -m pdb %<CR>", desc = "debug python file" } },
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete", "Move", "Chmod", "Mkdir", "SudoWrite" } },

  -- Debugging helpers for vim script
  { "tpope/vim-scriptease", cmd = { "Scriptnames", "Messages", "Verbose" } },

  -- Session management plugin
  { "tpope/vim-obsession", cmd = "Obsession" },

  -- Copy to the system clipboard through OSC 52 (useful over ssh)
  { "ojroques/vim-oscyank", enabled = vim.g.is_linux, cmd = { "OSCYank", "OSCYankRegister", "OSCYankVisual" } },

  -- Open URLs in the browser (macOS and Windows; Linux may be a server without GUI)
  {
    "tyru/open-browser.vim",
    enabled = vim.g.is_win or vim.g.is_mac,
    keys = {
      { "ob", "<Plug>(openbrowser-smart-search)", mode = { "n", "x" }, desc = "open link / search selection" },
    },
  },

  -- Edit browser text areas with nvim
  {
    "glacambre/firenvim",
    enabled = vim.g.is_win or vim.g.is_mac,
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    init = function()
      if not vim.g.started_by_firenvim then
        return
      end

      vim.o.guifont = vim.g.is_mac and "Iosevka Nerd Font:h18" or "Consolas"
      vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
          [".*"] = {
            cmdline = "neovim",
            priority = 0,
            selector = "textarea",
            takeover = "never",
          },
        },
      }

      local group = vim.api.nvim_create_augroup("firenvim", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function()
          vim.o.signcolumn = "no"
          vim.o.ruler = false
          vim.o.showcmd = false
          vim.o.laststatus = 0
          vim.o.showtabline = 0
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", { group = group, pattern = "sqlzoo*.txt", command = "set filetype=sql" })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = { "github.com_*.txt", "stackoverflow.com_*.txt" },
        command = "set filetype=markdown",
      })
    end,
  },

  -- Time tracking
  { "wakatime/vim-wakatime", lazy = false },
}
