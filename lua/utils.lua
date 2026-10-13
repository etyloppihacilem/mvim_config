local M = {}

--- Whether an executable is available in PATH.
---@param name string
---@return boolean
function M.executable(name)
  return vim.fn.executable(name) > 0
end

--- Whether a feature exists in Nvim, like `nvim-0.12` or `unix`.
---@param feat string
---@return boolean
function M.has(feat)
  return vim.fn.has(feat) == 1
end

--- Create a dir if it does not exist
---@param dir string
function M.may_create_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

return M
