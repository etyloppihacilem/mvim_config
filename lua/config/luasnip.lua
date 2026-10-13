local M = {}

--- (Re)load every snippet collection.
function M.loaders()
  -- VSCode format (friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()
  -- SnipMate format (vim-snippets)
  require("luasnip.loaders.from_snipmate").lazy_load()
  -- Lua format (my_snippets/)
  require("luasnip.loaders.from_lua").lazy_load { paths = { vim.g.lua_snippets_path } }
end

function M.setup(opts)
  local luasnip = require("luasnip")
  luasnip.setup(opts)

  M.loaders()

  -- Leave the snippet when leaving insert mode, so <Tab>/<C-j> do not jump back into it later
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("luasnip_unlink", { clear = true }),
    callback = function()
      if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
        luasnip.unlink_current()
      end
    end,
  })
end

return M
