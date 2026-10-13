-- Native LSP setup (Neovim 0.11+), see `:h lsp-quickstart`.
--
-- Server configurations are merged from, in order:
--   1. nvim-lspconfig's `lsp/<server>.lua` (defaults for cmd, filetypes, root markers)
--   2. this repo's `after/lsp/<server>.lua` (personal overrides, e.g. after/lsp/clangd.lua). They live in after/
--      so they are merged after nvim-lspconfig's files instead of being overridden by them.
--   3. `vim.lsp.config()` calls (the "*" config below applies to every server)
--
-- Servers installed through Mason are enabled automatically by mason-lspconfig (see lua/plugins/lsp.lua).
-- Servers installed another way are listed in `servers` below.
local api = vim.api
local diagnostic = vim.diagnostic

-- Servers not installed with Mason, enabled directly
local servers = { "clangd" }

------------------------------------------------------------------------
--                            diagnostics                             --
------------------------------------------------------------------------
diagnostic.config {
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [diagnostic.severity.ERROR] = "",
      [diagnostic.severity.WARN] = "",
      [diagnostic.severity.INFO] = "",
      [diagnostic.severity.HINT] = "",
    },
  },
  float = {
    border = "rounded",
    source = true,
  },
}

-- Show the diagnostics of the current line in a float when the cursor stops on it.
api.nvim_create_autocmd("CursorHold", {
  group = api.nvim_create_augroup("diagnostic_float", { clear = true }),
  callback = function()
    local cursor_pos = api.nvim_win_get_cursor(0)
    local last_pos = vim.b.diagnostics_pos
    vim.b.diagnostics_pos = cursor_pos
    if last_pos and last_pos[1] == cursor_pos[1] and last_pos[2] == cursor_pos[2] then
      return
    end

    diagnostic.open_float {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
      border = "rounded",
      source = true,
      prefix = " ",
      scope = "line",
    }
  end,
})

-- Put the diagnostics of one buffer (not the whole workspace) in the quickfix list
local function buffer_diagnostics_to_qf(bufnr)
  local items = diagnostic.toqflist(diagnostic.get(bufnr))
  vim.fn.setqflist({}, " ", { title = "Diagnostics", items = items })
  vim.cmd.copen()
end

------------------------------------------------------------------------
--                   keymaps and features on attach                   --
------------------------------------------------------------------------
-- Neovim already provides default LSP mappings (`:h lsp-defaults`): grn (rename), gra (code action),
-- grr (references), gri (implementation), grt (type definition), gO (document symbols), K (hover),
-- <C-s> in insert mode (signature help), [d / ]d (diagnostics). The mappings below come on top of them.
api.nvim_create_autocmd("LspAttach", {
  group = api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "go to definition")
    map("n", "<C-]>", vim.lsp.buf.definition, "go to definition")
    map("n", "K", vim.lsp.buf.hover, "hover documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "signature help")
    map("n", "<space>rn", vim.lsp.buf.rename, "variable rename")
    map("n", "gr", vim.lsp.buf.references, "show references")
    map("n", "[d", function()
      diagnostic.jump { count = -1, float = true }
    end, "previous diagnostic")
    map("n", "]d", function()
      diagnostic.jump { count = 1, float = true }
    end, "next diagnostic")
    map("n", "<space>qw", diagnostic.setqflist, "put window diagnostics to qf")
    map("n", "<space>qb", function()
      buffer_diagnostics_to_qf(bufnr)
    end, "put buffer diagnostics to qf")
    map("n", "<space>ca", vim.lsp.buf.code_action, "LSP code action")
    map("n", "<leader>cf", vim.lsp.buf.code_action, "LSP code action (fix)")
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
    map("n", "<space>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, "list workspace folder")

    if client:supports_method("textDocument/formatting") then
      map("n", "<space>f", vim.lsp.buf.format, "format code")
    end

    -- Highlight the symbol under the cursor and its usages
    if client:supports_method("textDocument/documentHighlight") then
      local group = api.nvim_create_augroup("lsp_document_highlight", { clear = false })
      api.nvim_clear_autocmds { group = group, buffer = bufnr }
      api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if vim.g.logging_level == "debug" then
      vim.notify(("Language server %s started!"):format(client.name), vim.log.levels.DEBUG, { title = "Nvim-config" })
    end
  end,
})

------------------------------------------------------------------------
--                              servers                               --
------------------------------------------------------------------------
vim.lsp.enable(servers)

-- Cycle between the clangd builds defined in lua/config/clangd.lua
api.nvim_create_user_command("ClangdSwitchCmd", function()
  local clangd = require("config.clangd")
  local variant = clangd.next_variant()
  vim.lsp.config("clangd", { cmd = clangd.cmd(variant) })

  -- Stop the running clients, then re-enable clangd so open buffers attach with the new command
  vim.lsp.enable("clangd", false)
  vim.defer_fn(function()
    vim.lsp.enable("clangd")
  end, 500)

  vim.notify("Clangd switched to: " .. variant, vim.log.levels.INFO)
end, { desc = "Cycle between clangd builds (local release, system, local debug)" })
