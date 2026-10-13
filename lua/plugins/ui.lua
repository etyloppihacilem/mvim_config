-- Colorschemes, statusline, bufferline, start screen and other visual plugins.
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

return {
  -- Colorschemes (loaded from init.lua with require("config.colorschemes").load(<name>))
  { "sainnhe/edge", lazy = false, priority = 1000 },
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "tanvirtin/monokai.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("config.statusline")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "BufEnter",
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    cond = firenvim_not_active,
    config = function()
      require("config.dashboard-nvim")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    config = function()
      require("config.indent-blankline")
    end,
  },

  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup {
        stages = "fade_in_slide_out",
        timeout = 1500,
        background_colour = "#2E3440",
      }
      vim.notify = notify
    end,
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- show WhichKey when pressing z= to select spelling suggestions
          suggestions = 9,
        },
        presets = {
          motions = true,
          text_objects = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      layout = {
        width = { min = 20, max = 300 },
        spacing = 3,
        align = "center",
      },
      show_help = true,
    },
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      {
        "<space>s",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
        silent = true,
        desc = "toggle nvim-tree",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.8, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 120,
        options = {
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
    },
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_resize_height = false,
      preview = {
        auto_preview = false,
      },
    },
  },
}
