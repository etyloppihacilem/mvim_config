local api = vim.api
local keymap = vim.keymap
local dashboard = require("dashboard")

local conf = {}
conf.header = {
  "    _   __         _    ___         ",
  "   / | / /__  ____| |  / (_)___ ___ ",
  "  /  |/ / _ \\/ __ \\ | / / / __ `__ \\",
  " / /|  /  __/ /_/ / |/ / / / / / / /",
  "/_/ |_/\\___/\\____/|___/_/_/ /_/ /_/ ",
  "                                    ",
}

conf.center = {
  {
    icon = "󰈞  ",
    desc = "Find File                               ",
    action = "Telescope find_files",
    key = "<Leader> f f",
  },
  {
    icon = "󰈢  ",
    desc = "Recently opened files                   ",
    action = "Telescope oldfiles",
    key = "<Leader> f r",
  },
  {
    icon = "󰈬  ",
    desc = "Project grep                            ",
    action = "lua require('telescope').extensions.live_grep_args.live_grep_args()",
    key = "<Leader> f g",
  },
  {
    icon = "  ",
    desc = "Project Todos                           ",
    action = "TodoTelescope",
    key = "<Leader> f t",
  },
  {
    icon = "  ",
    desc = "Show file tree                          ",
    action = "lua require('nvim-tree.api').tree.toggle()",
    key = "<Space> s",
  },
  {
    icon = "  ",
    desc = "Open Nvim config                        ",
    action = "tabnew $MYVIMRC | tcd %:p:h",
    key = "<Leader> e v",
  },
  {
    icon = "  ",
    desc = "New file                                ",
    action = "enew",
    key = "e",
  },
  {
    icon = "󰗼  ",
    desc = "Quit Nvim                               ",
    -- desc = "Quit Nvim                               ",
    action = "qa",
    key = "q",
  },
}

local preview = {
  preview = {
    command = "cat",
    file_path = vim.fn.stdpath("config") .. "dashboard-ansi.txt",
    file_width = 36,
    file_height = 6,
  },
}

dashboard.setup {
  theme = "doom",
  shortcut_type = "number",
  config = conf,
  preview = preview,
}

api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
  callback = function()
    keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
  end,
})
