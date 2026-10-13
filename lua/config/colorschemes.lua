--- Colorscheme settings. Each entry sets the options of one colorscheme and applies it.
--- Use `require("config.colorschemes").load("<name>")` to switch.
local M = {}

M.schemes = {
  onedark = function()
    vim.cmd.colorscheme("onedark")
  end,

  edge = function()
    vim.g.edge_enable_italic = 1
    vim.g.edge_better_performance = 1
    vim.g.edge_style = "aura"
    vim.cmd.colorscheme("edge")
  end,

  sonokai = function()
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_better_performance = 1
    vim.cmd.colorscheme("sonokai")
  end,

  gruvbox_material = function()
    -- foreground option can be material, mix, or original
    vim.g.gruvbox_material_foreground = "material"
    --background option can be hard, medium, soft
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1
    vim.cmd.colorscheme("gruvbox-material")
  end,

  nord = function()
    vim.cmd.colorscheme("nord")
  end,

  everforest = function()
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_better_performance = 1
    vim.cmd.colorscheme("everforest")
  end,

  nightfox = function()
    vim.cmd.colorscheme("nordfox")
  end,

  kanagawa = function()
    vim.cmd.colorscheme("kanagawa")
  end,

  catppuccin = function()
    -- available flavours: latte, frappe, macchiato, mocha
    require("catppuccin").setup { flavour = "frappe" }
    vim.cmd.colorscheme("catppuccin")
  end,

  onedarkpro = function()
    vim.cmd.colorscheme("onedark_vivid")
  end,

  monokai = function()
    vim.cmd.colorscheme("monokai_pro")
  end,

  material = function()
    vim.g.material_style = "oceanic"
    vim.cmd.colorscheme("material")
  end,
}

--- Load a colorscheme by name. Pass nothing to pick a random one.
---@param name? string
function M.load(name)
  if name == nil then
    local names = vim.tbl_keys(M.schemes)
    name = names[math.random(#names)]
  end

  local scheme = M.schemes[name]
  if scheme == nil then
    vim.notify("Invalid colorscheme: " .. name, vim.log.levels.ERROR, { title = "nvim-config" })
    return
  end

  local ok, err = pcall(scheme)
  if not ok then
    vim.notify(("Could not load colorscheme %s: %s"):format(name, err), vim.log.levels.WARN, { title = "nvim-config" })
  elseif vim.g.logging_level == "debug" then
    vim.notify("Colorscheme: " .. name, vim.log.levels.DEBUG, { title = "nvim-config" })
  end
end

return M
