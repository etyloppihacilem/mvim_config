-- Fuzzy finder.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      return require("config.telescope")
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("live_grep_args")
    end,
    keys = {
      {
        "<leader>fg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "telescope live grep",
      },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "telescope find files" },
      {
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        desc = "telescope find all files",
      },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "telescope find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "telescope help page" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "telescope find oldfiles" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "telescope find in current buffer" },
      { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "telescope find symbols" },
      { "<leader>ma", "<cmd>Telescope marks<CR>", desc = "telescope find marks" },
      { "<leader>cm", "<cmd>Telescope git_commits<CR>", desc = "telescope git commits" },
      { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "telescope git status" },
    },
  },
}
