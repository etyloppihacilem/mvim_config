local opt = vim.opt

-- change fillchars for folding, vertical split, end of buffer, and message separator
opt.fillchars = { fold = " ", vert = "│", eob = " ", msgsep = "‾" }

-- Split window below/right when creating horizontal/vertical windows
opt.splitbelow = true
opt.splitright = false

-- Time in milliseconds to wait for a mapped sequence to complete,
-- see https://unix.stackexchange.com/q/36882/221410 for more info
opt.timeoutlen = 500
opt.updatetime = 500 -- For CursorHold events

-- Always use the system clipboard for delete, yank, change and put, see https://stackoverflow.com/q/30691466/6064933.
-- Deferred because detecting the clipboard provider is slow.
vim.schedule(function()
  if vim.fn["provider#clipboard#Executable"]() ~= "" then
    opt.clipboard:append("unnamedplus")
  end
end)

-- Disable creating swapfiles, see https://stackoverflow.com/q/821902/6064933
opt.swapfile = false

-- Ignore certain files and folders when globing
-- stylua: ignore
opt.wildignore:append {
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**",
  "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.tiff", "*.svg", "*.ico",
  "*.pyc", "*.pkl",
  "*.DS_Store",
  "*.aux", "*.bbl", "*.blg", "*.brf", "*.fls", "*.fdb_latexmk", "*.synctex.gz", "*.xdv",
}
opt.wildignorecase = true -- ignore file and dir name cases in cmd-completion

-- Backups go to a dedicated directory, and skip the patterns in 'wildignore'
opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
opt.backupskip = vim.o.wildignore
opt.backup = true -- create backup for files
opt.backupcopy = "yes" -- copy the original file to backupdir and overwrite it

opt.colorcolumn = "120"

-- General tab settings
opt.tabstop = 2 -- number of visual spaces per TAB
opt.softtabstop = 2 -- number of spaces in tab when editing
opt.shiftwidth = 2 -- number of spaces to use for autoindent
opt.expandtab = true -- expand tab to spaces so that tabs are spaces

-- Set matching pairs of characters and highlight matching brackets
opt.matchpairs:append { "<:>", "「:」", "『:』", "【:】", "“:”", "‘:’", "《:》" }

opt.number = true
opt.relativenumber = false

-- Ignore case in general, but become case-sensitive when uppercase is present
opt.ignorecase = true
opt.smartcase = true

-- File encoding settings
opt.fileencoding = "utf-8"
opt.fileencodings = { "ucs-bom", "utf-8", "cp936", "gb18030", "big5", "euc-jp", "euc-kr", "latin1" }

-- Break line at predefined characters
opt.linebreak = true
-- Character to show before the lines that have been soft-wrapped
opt.showbreak = "↪"
opt.wrap = true

-- List all matches and complete till longest common string
opt.wildmode = "list:longest"

-- Minimum lines to keep above and below cursor when scrolling
opt.scrolloff = 1

-- Use mouse to select and resize windows, etc.
opt.mouse = "a"
opt.mousemodel = "popup"
opt.mousescroll = { "ver:1", "hor:1" }

-- Disable showing current mode on command line since statusline plugins can show it.
opt.showmode = false
opt.ruler = false

opt.fileformats = { "unix", "dos" } -- Fileformats to use for new files

-- Ask for confirmation when handling unsaved or read-only files
opt.confirm = true

opt.visualbell = true
opt.errorbells = false
opt.history = 500 -- The number of command and search history to keep

-- Use list mode and customized listchars
opt.list = true
opt.listchars = { tab = "▸ ", extends = "❯", precedes = "❮", nbsp = "␣" }

-- Auto-write the file based on some condition
opt.autowrite = true

-- Show hostname, full path of file and last-mod time on the window title.
opt.title = true
opt.titlestring = "%{utils#Get_titlestr()}"

-- Persistent undo even after you close a file and re-open it
opt.undofile = true

-- c: no "match xx of xx" messages during completion, S: no search count (nvim-hlslens shows it),
-- I: no intro message
opt.shortmess:append("cSI")

-- Completion behaviour
opt.completeopt:append("menuone") -- Show menu even if there is only one item
opt.completeopt:remove("preview") -- Disable the preview window

opt.pumheight = 10 -- Maximum number of items to show in popup menu
opt.pumblend = 10 -- pseudo transparency for completion menu
opt.winblend = 0 -- pseudo transparency for floating window

-- Insert mode key word completion setting
opt.complete:append("kspell")
opt.complete:remove { "w", "b", "u", "t" }

opt.spelllang = { "en", "fr" } -- Spell languages
opt.spellsuggest:append("9") -- show 9 spell suggestions at most

-- Align indent to next multiple value of shiftwidth.
opt.shiftround = true

opt.virtualedit = "block" -- Virtual edit is useful for visual block edit

-- Correctly break multi-byte characters such as CJK, see https://stackoverflow.com/q/32669814/6064933
opt.formatoptions:append("mM")

-- Tilde (~) is an operator, thus must be followed by motions like `e` or `w`.
opt.tildeop = true

opt.synmaxcol = 250 -- Text after this column number is not highlighted
opt.startofline = false

-- External program to use for grep command
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

opt.termguicolors = true
opt.background = "dark"

-- Cursor shape in various modes; colors are set in autocmds.lua (custom highlights)
opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20"

opt.signcolumn = "yes:1"

-- Remove certain character from file name pattern matching
opt.isfname:remove { "=", "," }

-- diff options
opt.diffopt = {
  "vertical", -- show diff in vertical position
  "filler", -- show filler for deleted lines
  "closeoff", -- turn off diff when one file window is closed
  "context:3", -- context for diff
  "internal",
  "indent-heuristic",
  "algorithm:histogram",
  "linematch:60",
}

opt.foldenable = false
