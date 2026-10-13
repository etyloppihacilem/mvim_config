-- Language specific plugins: Markdown, LaTeX, Python, Lisp, tmux, LC-3, Textual CSS.
local utils = require("utils")

return {
  -- Markdown
  {
    "preservim/vim-markdown",
    ft = "markdown",
    init = function()
      vim.g.vim_markdown_folding_disabled = 1 -- Disable header folding
      vim.g.vim_markdown_conceal = 1
      -- Disable math tex conceal and syntax highlight
      vim.g.tex_conceal = ""
      vim.g.vim_markdown_math = 0
      -- Support front matter of various format
      vim.g.vim_markdown_frontmatter = 1 -- YAML
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
      -- Let the TOC window autofit so that it doesn't take too much space
      vim.g.vim_markdown_toc_autofit = 1
    end,
  },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = "markdown" },

  -- Markdown previewing in the browser (macOS and Windows only)
  {
    "iamcco/markdown-preview.nvim",
    enabled = vim.g.is_win or vim.g.is_mac,
    build = "cd app && npm install",
    ft = "markdown",
    keys = {
      { "<M-m>", "<cmd>MarkdownPreview<CR>", ft = "markdown", silent = true, desc = "markdown preview" },
      { "<M-S-m>", "<cmd>MarkdownPreviewStop<CR>", ft = "markdown", silent = true, desc = "stop markdown preview" },
    },
    init = function()
      -- Do not close the preview tab when switching to other buffers
      vim.g.mkdp_auto_close = 0
    end,
  },

  -- Grammar checking with LanguageTool (macOS only)
  {
    "rhysd/vim-grammarous",
    enabled = vim.g.is_mac,
    ft = "markdown",
    init = function()
      vim.g["grammarous#languagetool_cmd"] = "languagetool"
      -- stylua: ignore
      vim.g["grammarous#disabled_rules"] = {
        ["*"] = {
          "WHITESPACE_RULE", "EN_QUOTES", "ARROWS", "SENTENCE_WHITESPACE",
          "WORD_CONTAINS_UNDERSCORE", "COMMA_PARENTHESIS_WHITESPACE",
          "EN_UNPAIRED_BRACKETS", "UPPERCASE_SENTENCE_START",
          "ENGLISH_WORD_REPEAT_BEGINNING_RULE", "DASH_RULE", "PLUS_MINUS",
          "PUNCTUATION_PARAGRAPH_END", "MULTIPLICATION_SIGN", "PRP_CHECKOUT",
          "CAN_CHECKOUT", "SOME_OF_THE", "DOUBLE_PUNCTUATION", "HELL",
          "CURRENCY", "POSSESSIVE_APOSTROPHE", "ENGLISH_WORD_REPEAT_RULE",
          "NON_STANDARD_WORD", "AU", "DATE_NEW_YEAR",
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("grammarous_map", { clear = true }),
        pattern = "markdown",
        callback = function(args)
          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, remap = true })
          end
          map("<leader>x", "<Plug>(grammarous-close-info-window)")
          map("<c-n>", "<Plug>(grammarous-move-to-next-error)")
          map("<c-p>", "<Plug>(grammarous-move-to-previous-error)")
        end,
      })
    end,
  },

  -- LaTeX
  {
    "lervag/vimtex",
    enabled = utils.executable("latex"),
    lazy = false, -- vimtex must not be lazy-loaded (its own ftplugin handles that)
    init = function()
      vim.g.vimtex_compiler_latexmk = { build_dir = "build" }
      vim.g.vimtex_toc_config = {
        name = "TOC",
        layers = { "content", "todo", "include" },
        resize = 1,
        split_width = 30,
        todo_sorted = 0,
        show_help = 1,
        show_numbers = 1,
        mode = 2,
      }

      if vim.g.is_win then
        vim.g.vimtex_view_general_viewer = "SumatraPDF"
        vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
      elseif vim.g.is_mac then
        vim.g.vimtex_view_general_viewer = "/Applications/Skim.app/Contents/SharedSupport/displayline"
        vim.g.vimtex_view_general_options = "-r @line @pdf @tex"
      end

      local group = vim.api.nvim_create_augroup("vimtex_common", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "tex",
        callback = function(args)
          -- Write the server name for inverse search,
          -- see https://jdhao.github.io/2021/02/20/inverse_search_setup_neovim_vimtex/.
          local tmp = vim.g.is_win and vim.env.TEMP or "/tmp"
          vim.fn.writefile({ vim.v.servername }, tmp .. "/vimtexserver.txt")
          vim.keymap.set("n", "<F9>", "<plug>(vimtex-compile)", { buffer = args.buf, remap = true })
        end,
      })

      if vim.g.is_mac then
        -- Refresh Skim after a successful compilation,
        -- adapted from https://gist.github.com/skulumani/7ea00478c63193a832a6d3f2e661a536.
        vim.api.nvim_create_autocmd("User", {
          group = group,
          pattern = "VimtexEventCompileSuccess",
          callback = function()
            local cmd = { vim.g.vimtex_view_general_viewer, "-r" }
            if vim.fn.system("pgrep Skim") ~= "" then
              table.insert(cmd, "-g")
            end
            vim.list_extend(cmd, { tostring(vim.fn.line(".")), vim.b.vimtex.out(), vim.fn.expand("%:p") })
            vim.fn.jobstart(cmd)
          end,
        })
      end
    end,
  },

  -- Python virtual environments (<leader>vs), requires fd
  {
    "linux-cultist/venv-selector.nvim",
    enabled = utils.executable("fd") or utils.executable("fdfind"),
    dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    ft = "python",
    cmd = { "VenvSelect", "VenvSelectCached" },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "select python venv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "select cached python venv" },
    },
    opts = {},
  },

  -- IDE for Lisp (`:StartVlime` starts the server)
  {
    "vlime/vlime",
    enabled = utils.executable("sbcl"),
    ft = "lisp",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
      vim.api.nvim_create_user_command("StartVlime", function()
        vim.fn.jobstart { "sbcl", "--load", plugin.dir .. "/lisp/start-vlime.lisp" }
      end, { desc = "start the vlime server" })
    end,
  },

  -- .tmux.conf syntax highlighting and setting check
  { "tmux-plugins/vim-tmux", enabled = utils.executable("tmux"), ft = "tmux" },

  -- LC-3 assembly
  { "zacharied/lc3.vim" },

  -- Textual CSS (.tcss)
  {
    "cachebag/nvim-tcss",
    opts = { enable = true },
  },
}
