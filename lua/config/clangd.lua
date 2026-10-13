--- clangd builds that `:ClangdSwitchCmd` cycles through (see lua/core/lsp.lua and after/lsp/clangd.lua).
local M = {}

local args = {
  "--completion-style=detailed",
  "--function-arg-placeholders=1",
  "--clang-tidy",
  "-log=verbose",
}

M.order = { "local_build", "system", "debug_build" }

M.binaries = {
  local_build = "/home/sherlock/Desktop/clangd/build-release/bin/clangd",
  system = "clangd",
  debug_build = "/home/sherlock/Desktop/clangd/build-debug/bin/clangd",
}

-- Start with the local release build when it exists, the system clangd otherwise.
M.current = vim.fn.executable(M.binaries.local_build) == 1 and "local_build" or "system"

---@param variant? string defaults to the current variant
---@return string[]
function M.cmd(variant)
  return vim.list_extend({ M.binaries[variant or M.current] }, args)
end

--- Move to the next variant and return its name.
---@return string
function M.next_variant()
  local idx = 1
  for i, name in ipairs(M.order) do
    if name == M.current then
      idx = i
    end
  end
  M.current = M.order[idx % #M.order + 1]
  return M.current
end

return M
