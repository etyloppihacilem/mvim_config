# NeoVim config

Personal Neovim configuration, originally forked from [jdhao/nvim-config](https://github.com/jdhao/nvim-config.git) and heavily modified since.

It targets the **latest Neovim stable release (0.12+)** and uses the native LSP client (`vim.lsp.config` / `vim.lsp.enable`).

# Layout

```
init.lua                 entry point: loads lua/core/* then the colorscheme
lua/
  core/
    globals.lua          global variables, leader key, disabled builtin plugins
    options.lua          editor options
    filetypes.lua        custom filetype detection (vim.filetype.add)
    autocmds.lua         autocommands
    keymaps.lua          plugin-independent mappings
    lsp.lua              native LSP: diagnostics, mappings on LspAttach, enabled servers, :ClangdSwitchCmd
    lazy.lua             lazy.nvim bootstrap, imports every spec in lua/plugins/
  plugins/               lazy.nvim specs, one file per theme
    completion.lua       nvim-cmp, LuaSnip
    lsp.lua              nvim-lspconfig, Mason, conform.nvim, fidget, lazydev
    treesitter.lua       nvim-treesitter (main branch)
    telescope.lua        telescope and its mappings
    git.lua              fugitive, gitsigns, gitlinker, flog...
    editor.lua           text objects, pairs, search, yank history, todo comments...
    ui.lua               colorschemes, lualine, bufferline, dashboard, nvim-tree, which-key...
    lang.lua             markdown, vimtex, python venvs, lisp, tmux, lc3, tcss
    tools.lua            vista, asyncrun, nvim-gdb, firenvim...
  config/                bigger plugin configurations required from the specs
  utils.lua
after/
  lsp/                   per-server LSP settings, merged over nvim-lspconfig's defaults
  ftplugin/              per-filetype settings
autoload/, plugin/       vim script helpers and commands (Redir, Edit, Datetime, ToPDF, LogAutocmds)
my_snippets/             LuaSnip snippets (Lua format)
scripts/header.py        42-style file header (<F1>)
```

# LSP

Servers are configured the Neovim 0.11+ way:

- default configurations come from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)'s `lsp/` directory;
- personal settings go in `after/lsp/<server>.lua` (see `after/lsp/clangd.lua`);
- servers installed with `:Mason` are enabled automatically by mason-lspconfig, the list to install is in `lua/plugins/lsp.lua`;
- servers installed another way are listed in `servers` at the top of `lua/core/lsp.lua` (currently `clangd`).

`:ClangdSwitchCmd` cycles between the local release build, the system clangd and the local debug build of clangd.

Neovim's default LSP mappings (`grn`, `gra`, `grr`, `gri`, `gO`, `K`, `[d`, `]d`...) are available, plus the mappings defined in `lua/core/lsp.lua` (`gd`, `gr`, `<space>rn`, `<space>ca`, `<space>f`...).

# Install

Requirements:

- Neovim 0.12 or later
- `git`, `curl`, `tar`, a C compiler and `make` (LuaSnip's jsregexp)
- [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) 0.26.1 or later, used by nvim-treesitter to build parsers (install it with your package manager or from the GitHub releases, not npm)
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) for telescope and todo-comments
- `fd` for venv-selector (the plugin is skipped without it)
- a [Nerd Font](https://www.nerdfonts.com/). I recommend the symbols only font with a `symbol_map` override in kitty, see [kitty's FAQ](https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font).

Clone the repository to `~/.config/nvim` and start `nvim`: lazy.nvim installs the plugins, Mason installs the language servers and formatters,
and nvim-treesitter builds the parsers. Run `:checkhealth` if something looks wrong.

Optionally, a Python virtual environment named `venv_nvim` next to `init.lua` (see `requirements.txt`) is added to `PATH` when it exists.
