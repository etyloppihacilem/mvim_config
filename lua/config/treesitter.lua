require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "php",
    "python",
    "rust",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
  },
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "help" }, -- list of language that will be disabled
  },
}
