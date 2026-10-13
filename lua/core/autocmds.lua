local api = vim.api
local fn = vim.fn

local utils = require("utils")

local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- Do not use smart case in command line mode, see https://vi.stackexchange.com/a/16511/15292.
local smartcase_group = augroup("dynamic_smartcase")
api.nvim_create_autocmd("CmdlineEnter", {
  group = smartcase_group,
  pattern = ":",
  callback = function()
    vim.o.smartcase = false
  end,
})
api.nvim_create_autocmd("CmdlineLeave", {
  group = smartcase_group,
  pattern = ":",
  callback = function()
    vim.o.smartcase = true
  end,
})

-- Terminal buffers: no line numbers, and start in insert mode
api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_settings"),
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd.startinsert()
  end,
})

-- More accurate syntax highlighting (see `:h syn-sync`)
api.nvim_create_autocmd("BufEnter", {
  group = augroup("accurate_syn_highlight"),
  command = "syntax sync fromstart",
})

-- Return to last cursor position when opening a file, unless a go-to-line argument (like `+23`) was given.
api.nvim_create_autocmd("BufReadPost", {
  group = augroup("resume_cursor_position"),
  callback = function(args)
    local mark = api.nvim_buf_get_mark(args.buf, '"')
    local line_count = api.nvim_buf_line_count(args.buf)
    if mark[1] <= 1 or mark[1] > line_count or vim.bo[args.buf].filetype:find("commit") then
      return
    end

    for _, arg in ipairs(vim.v.argv) do
      if arg:match("^%+%d+$") then
        return
      end
    end

    vim.cmd([[normal! g`"zvzz]])
  end,
})

-- Define or override some highlight groups
local function custom_highlight()
  -- For yank highlight
  api.nvim_set_hl(0, "YankColor", { ctermfg = 59, ctermbg = 41, fg = "#34495E", bg = "#2ECC71" })
  -- Cursor colors (used by 'guicursor')
  api.nvim_set_hl(0, "Cursor", { bold = true, fg = "black", bg = "orange" })
  api.nvim_set_hl(0, "Cursor2", { fg = "black", bg = "orange" })
  -- For floating windows border highlight
  api.nvim_set_hl(0, "FloatBorder", { fg = "LightGreen" })
  -- highlight for matching parentheses
  api.nvim_set_hl(0, "MatchParen", { bold = true, underline = true })
  -- Highlight of the symbol under cursor (LSP document highlight)
  api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
  api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
  api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
end
api.nvim_create_autocmd("ColorScheme", {
  group = augroup("custom_highlight"),
  callback = custom_highlight,
})
custom_highlight()

-- Quit Nvim if the only windows left are quickfix, vista or nvim-tree.
api.nvim_create_autocmd("BufEnter", {
  group = augroup("auto_close_win"),
  callback = function()
    local quit_filetypes = { "qf", "vista", "NvimTree" }
    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
      local ft = vim.bo[api.nvim_win_get_buf(win)].filetype
      if not vim.tbl_contains(quit_filetypes, ft) then
        return
      end
    end
    vim.cmd.qall()
  end,
})

-- Fire `User InGitRepo` when inside a git repository (used to lazy-load git plugins).
api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = augroup("git_repo_check"),
  callback = function()
    vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }, function(res)
      if res.code == 0 and vim.startswith(res.stdout, "true") then
        vim.schedule(function()
          api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
        end)
      end
    end)
  end,
})

-- Make very large files (> 10MB) cheap to open, see https://vi.stackexchange.com/a/169/15292
api.nvim_create_autocmd("BufReadPre", {
  group = augroup("LargeFile"),
  callback = function(args)
    local size = fn.getfsize(args.file)
    if size > 10485760 or size == -2 then
      vim.opt.eventignore:append("all")
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].bufhidden = "unload"
      vim.bo[args.buf].buftype = "nowrite"
      vim.bo[args.buf].undolevels = -1
    else
      vim.opt.eventignore:remove("all")
    end
  end,
})

-- Display a message when the current file is not in utf-8 format.
api.nvim_create_autocmd("BufRead", {
  group = augroup("non_utf8_file"),
  callback = function()
    if vim.bo.fileencoding ~= "utf-8" then
      vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
    end
  end,
})

-- Highlight yanked region and keep the cursor where it was when yanking.
local yank_group = augroup("highlight_yank")
api.nvim_create_autocmd("CursorMoved", {
  group = yank_group,
  callback = function()
    vim.b.current_cursor_pos = fn.getcurpos()
  end,
})
api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.hl.on_yank { higroup = "YankColor", timeout = 300 }
    if vim.v.event.operator == "y" and vim.b.current_cursor_pos then
      fn.setpos(".", vim.b.current_cursor_pos)
    end
  end,
})

-- Auto-create dir when saving a file, in case some intermediate directory does not exist
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(ctx)
    if ctx.match:match("^%w%w+://") then
      return
    end
    utils.may_create_dir(fn.fnamemodify(ctx.file, ":p:h"))
  end,
})

-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
local autoread_group = augroup("auto_read")
api.nvim_create_autocmd("FileChangedShellPost", {
  group = autoread_group,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
  end,
})
api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  group = autoread_group,
  callback = function()
    if fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
})

-- Resize all windows when we resize the terminal
api.nvim_create_autocmd("VimResized", {
  group = augroup("win_autoresize"),
  desc = "autoresize windows on resizing operation",
  command = "wincmd =",
})

-- Open nvim-tree when nvim is started on a directory
api.nvim_create_autocmd("VimEnter", {
  group = augroup("open_tree_on_dir"),
  callback = function(data)
    if fn.isdirectory(data.file) ~= 1 then
      return
    end
    vim.cmd.enew()
    vim.cmd.bwipeout(data.buf)
    require("nvim-tree.api").tree.open()
  end,
})
