local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine
  {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    -- event = 'InsertEnter',
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind-nvim",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-emoji",
      -- "quangnguyen30192/cmp-nvim-ultisnips",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        event = "InsertEnter",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("config.luasnip").luasnip(opts)
        end,
      },
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return true --false
    end,
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Python indent (follows the PEP8 style)
  -- { "Vimjas/vim-python-pep8-indent", ft = { "python" } },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  { "machakann/vim-swap", event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  {
    "vlime/vlime",
    enabled = function()
      if utils.executable("sbcl") then
        return true
      end
      return false
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
    ft = { "lisp" },
  },

  -- Super fast buffer jump
  -- {
  --     "smoka7/hop.nvim",
  --     event = "VeryLazy",
  --     config = function()
  --     vim.defer_fn(function()
  --         require("config.nvim_hop")
  --     end, 2000)
  --     end,
  -- },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return require("config.telescope")
    end,
    config = function(_, opts)
      -- dofile("telescope")
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("live_grep_args")
    end,
    -- telescope
    keys = {
      { "n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" } },
      { "n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" } },
      { "n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" } },
      { "n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" } },
      { "n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" } },
      {
        "n",
        "<leader>fz",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        { desc = "telescope find in current buffer" },
      },
      { "n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" } },
      { "n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" } },
      { "n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" } },
      { "n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" } },
      { "n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" } },
      {
        "n",
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        { desc = "telescope find all files" },
      },
    },
  },

  -- A list of colorscheme plugin you may want to try. Find what suits you.
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/edge", lazy = true },
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

  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

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
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
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
      vim.defer_fn(function()
        require("config.nvim-notify")
      end, 2000)
    end,
  },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we maybe in a server which disables GUI.
  {
    "tyru/open-browser.vim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      else
        return false
      end
    end,
    event = "VeryLazy",
  },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  {
    "liuchengxu/vista.vim",
    enabled = function()
      if utils.executable("ctags") then
        return true
      else
        return false
      end
    end,
    cmd = "Vista",
  },

  -- Snippet engine and snippet template
  {
    "SirVer/ultisnips",
    dependencies = {
      "honza/vim-snippets",
    },
    event = "InsertEnter",
  },

  -- Automatic insertion and deletion of a pair of characters
  { "Raimondi/delimitMate", event = "InsertEnter" },

  -- Comment plugin
  -- { "tpope/vim-commentary", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy" },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- better UI for some nvim actions
  { "stevearc/dressing.nvim" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    cmd = { "YankyRingHistory" },
    config = function()
      require("config.yanky")
    end,
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat", event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  {
    "lyokha/vim-xkbswitch",
    enabled = function()
      if vim.g.is_mac and utils.executable("xkbswitch") then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  {
    "Neur1n/neuims",
    enabled = function()
      if vim.g.is_win then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  -- Auto format tools
  {
    "stevearc/conform.nvim",
    opts = {},
  },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog", cmd = { "Flog" } },
  { "christoomey/vim-conflicted", cmd = { "Conflicted" } },
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Better git commit experience
  { "rhysd/committia.vim", lazy = true },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("config.bqf")
    end,
  },

  -- Another markdown plugin
  { "preservim/vim-markdown", ft = { "markdown" } },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = { "Tabularize" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("config.zen-mode")
    end,
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim", event = "VeryLazy" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  -- { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Add indent object for vim (useful for languages like Python)
  -- { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      if utils.executable("latex") then
        return true
      end
      return false
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      if utils.executable("tmux") then
        return true
      end
      return false
    end,
    ft = { "tmux" },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "BufRead" },
  { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },
  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    lazy = true,
  },

  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      if vim.g.is_win or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- Session management plugin
  { "tpope/vim-obsession", cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      if vim.g.is_linux then
        return true
      end
      return false
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  -- The missing auto-completion for cmdline!
  -- {
  --   "gelguy/wilder.nvim",
  --   build = ":UpdateRemotePlugins",
  -- },
  -- {
  --     "hrsh7th/cmp-buffer",
  --     lazy = false,
  -- },
  -- {
  --     "hrsh7th/cmp-cmdline",
  --     lazy = false,
  -- },
  -- {
  --     "hrsh7th/cmp-nvim-lsp", -- Source LSP pour nvim-cmp
  --     lazy = true,
  -- },
  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.defer_fn(function()
        require("config.which-key")
      end, 2000)
    end,
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = { "<space>s" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  { "ii14/emmylua-nvim", ft = "lua" },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    tag = "legacy",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  { "wakatime/vim-wakatime" },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    branch = "regexp", -- This is the regexp branch, use this for the new version
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
  -- {
  --   "nvim-orgmode/orgmode",
  --   dependencies = {
  --     { "nvim-treesitter/nvim-treesitter", lazy = true },
  --   },
  --   event = "VeryLazy",
  --   config = function()
  --     -- Load treesitter grammar for org
  --     -- require('orgmode').setup_ts_grammar()
  --     -- no longer required
  --
  --     -- Setup treesitter
  --     require("nvim-treesitter.configs").setup {
  --       highlight = {
  --         enable = true,
  --         additional_vim_regex_highlighting = { "org" },
  --       },
  --       ensure_installed = { "org" },
  --     }
  --
  --     -- Setup orgmode
  --     require("orgmode").setup {
  --       org_agenda_files = "~/orgfiles/**/*",
  --       org_default_notes_file = "~/orgfiles/refile.org",
  --     }
  --   end,
  -- },
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "github/copilot.vim",
  },
  {
    "zacharied/lc3.vim",
  },
  {
    "cachebag/nvim-tcss",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false, -- required ??
    opts = {
      signs = false, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTI", "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", "HERE" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS):\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
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
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },
}

-- configuration for lazy itself.
local lazy_opts = {
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
}

require("lazy").setup(plugin_specs, lazy_opts)
require("mason").setup {
  ensure_installed = {
    "prettier",
    "stylua",
  },
}
require("mason-lspconfig").setup {
  ensure_installed = {
    "ruff",
    "pylsp",
  },
}

require("Comment").setup()
-- require("luasnip.loaders.from_vscode").lazy_load()
-- require'luasnip'.filetype_extend("ruby", {"rails"})
require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    -- python = { "isort", "pylsp" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    sh = { "beautysh" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
  },
}
require("tcss").setup {
  -- Enable syntax highlighting (default: true)
  enable = true,
  -- Custom color overrides
  colors = {
    -- Add custom highlighting rules here
  },
}
