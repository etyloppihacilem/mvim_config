-- Git integration. `User InGitRepo` is fired from lua/core/autocmds.lua when nvim runs inside a git repo.
return {
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    cmd = { "Git", "G", "Gdiffsplit", "Gwrite", "Gread" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git add" },
      { "<leader>gc", "<cmd>Git commit --verbose<cr>", desc = "Git commit" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
      { "<leader>gpl", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gpu", "<cmd>15 split|term git push<cr>", desc = "Git push" },
    },
    config = function()
      -- convert git to Git in command line mode
      vim.fn["utils#Cabbrev"]("git", "Git")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" }, dependencies = { "tpope/vim-fugitive" } },
  { "christoomey/vim-conflicted", cmd = "Conflicted", dependencies = { "tpope/vim-fugitive" } },

  -- Permalinks to the current lines (<leader>gl) and browse the repo (<leader>gb)
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in the sign column
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Better git commit experience (diff and status next to the commit message)
  { "rhysd/committia.vim", lazy = false },
}
