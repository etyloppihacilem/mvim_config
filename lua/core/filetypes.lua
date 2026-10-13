-- Custom filetype detection, see `:h vim.filetype.add()`
vim.filetype.add {
  extension = {
    pdc = "markdown",
    snippets = "snippets",
    template = "nginx",
    tpp = "cpp", -- C++ template implementation files
  },
}
