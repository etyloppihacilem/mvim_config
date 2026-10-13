local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

local formatting = {
  format = lspkind.cmp_format {
    mode = "symbol_text",
    menu = {
      nvim_lsp = "[LSP]",
      luasnip = "[Snip]",
      async_path = "[Path]",
      buffer = "[Buffer]",
      emoji = "[Emoji]",
      omni = "[Omni]",
      cmdline = "[Cmd]",
    },
    show_labelDetails = true,
    maxwidth = 40,
    ellipsis_char = "...",
  },
}

-- Complete words from every buffer, not only the current one
local buffer_source = {
  name = "buffer",
  keyword_length = 2,
  option = {
    get_bufnrs = function()
      return vim.api.nvim_list_bufs()
    end,
  },
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- Expand a snippet or jump to its next / previous placeholder
    ["<C-j>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp", priority = 10 },
    { name = "luasnip" },
    { name = "async_path", priority = 5 },
    buffer_source,
  },
  completion = {
    keyword_length = 1,
    completeopt = "menu,noselect",
  },
  view = {
    entries = "custom",
  },
  formatting = formatting,
}

cmp.setup.filetype("tex", {
  sources = {
    { name = "omni" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 2 },
    { name = "async_path" },
  },
})

-- Completion in the command line: search with `/` and `?`, commands with `:`
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { buffer_source },
  formatting = formatting,
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "async_path" },
  }, {
    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
  }),
  formatting = formatting,
})

-- Colors inspired by VS Code dark theme, see
-- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
local function set_cmp_highlights()
  local hl = function(name, val)
    vim.api.nvim_set_hl(0, name, val)
  end
  hl("CmpItemMenu", { link = "Comment" })
  hl("CmpItemAbbrDeprecated", { strikethrough = true, fg = "#808080" })
  hl("CmpItemAbbrMatch", { fg = "#569CD6" })
  hl("CmpItemAbbrMatchFuzzy", { fg = "#569CD6" })
  hl("CmpItemKindVariable", { fg = "#9CDCFE" })
  hl("CmpItemKindInterface", { fg = "#9CDCFE" })
  hl("CmpItemKindText", { fg = "#9CDCFE" })
  hl("CmpItemKindFunction", { fg = "#C586C0" })
  hl("CmpItemKindMethod", { fg = "#C586C0" })
  hl("CmpItemKindKeyword", { fg = "#D4D4D4" })
  hl("CmpItemKindProperty", { fg = "#D4D4D4" })
  hl("CmpItemKindUnit", { fg = "#D4D4D4" })
end
set_cmp_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("cmp_highlights", { clear = true }),
  callback = set_cmp_highlights,
})
