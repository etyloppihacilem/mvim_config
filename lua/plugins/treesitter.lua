-- Tree-sitter parsers and queries.
-- nvim-treesitter's `main` branch is a rewrite for Neovim 0.12: it only installs parsers and queries,
-- highlighting is started with the builtin `vim.treesitter.start()`.
-- Requires the `tree-sitter` CLI (0.26.1+) and a C compiler to build parsers.
local parsers = {
  "asm",
  "bash",
  "c",
  "cpp",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "php",
  "python",
  "rust",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the plugin does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      -- Enable tree-sitter highlighting for every filetype that has a parser installed
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
