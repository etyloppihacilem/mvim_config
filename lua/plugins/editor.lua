-- Editing helpers: text objects, pairs, search, yank history, todo comments...
-- Commenting uses Neovim's builtin `gc` / `gcc` (`:h commenting`).
local utils = require("utils")

return {
  -- Show match number and index for searching (mappings for n, N, *, # in lua/config/hlslens.lua)
  {
    "kevinhwang91/nvim-hlslens",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },

  -- Automatic insertion and deletion of a pair of characters
  { "Raimondi/delimitMate", event = "InsertEnter" },

  -- Modern matchit implementation
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- Improve performance
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_insert_timeout = 30
      -- Enhanced matching with matchup plugin
      vim.g.matchup_override_vimtex = 1
      -- Whether to enable matching inside comment or string
      vim.g.matchup_delim_noskips = 0
      -- Show offscreen match pair in popup window
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- Additional powerful text objects
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Swap function arguments (g< g> gs)
  { "machakann/vim-swap", event = "VeryLazy" },

  -- Python-related text objects
  { "jeetsukumaran/vim-pythonsense", ft = "python" },

  -- Repeat plugin maps with .
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- Escape insert mode with jk without lagging
  {
    "nvim-zh/better-escape.vim",
    event = "InsertEnter",
    init = function()
      vim.g.better_escape_interval = 200
    end,
  },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    cmd = "YankyRingHistory",
    keys = {
      -- cycle through the yank history, only work after paste
      { "[y", "<Plug>(YankyCycleForward)", desc = "yank history forward" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "yank history backward" },
    },
    opts = {
      ring = {
        history_length = 50,
        storage = "memory",
      },
      preserve_cursor_position = {
        enabled = false,
      },
    },
  },

  -- Show undo history visually
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle", "MundoShow" },
    keys = { { "<Space>u", "<cmd>MundoToggle<CR>", silent = true, desc = "toggle undo tree" } },
    init = function()
      vim.g.mundo_verbose_graph = 0
      vim.g.mundo_width = 80
    end,
  },

  -- Show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- Unicode characters (ga shows info about the character under cursor)
  {
    "chrisbra/unicode.vim",
    keys = { { "ga", "<Plug>(UnicodeGA)", desc = "unicode info" } },
    cmd = { "UnicodeSearch", "UnicodeName", "UnicodeTable", "Digraphs" },
  },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = "Tabularize" },

  -- Input method switching
  {
    "lyokha/vim-xkbswitch",
    enabled = vim.g.is_mac and utils.executable("xkbswitch"),
    event = "InsertEnter",
    init = function()
      vim.g.XkbSwitchEnabled = 1
    end,
  },
  { "Neur1n/neuims", enabled = vim.g.is_win, event = "InsertEnter" },

  -- Highlight and search TODO / FIXME / ... comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "telescope find todos" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
    opts = {
      signs = false,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTI", "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", "HERE" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE",
        bg = "BOLD",
      },
      merge_keywords = true,
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "bg",
        after = "fg",
        pattern = [[.*<(KEYWORDS):\s*]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },
}
