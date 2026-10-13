-- Turn off syntax highlighting for large YAML files.
if vim.fn.line("$") > 500 then
  vim.bo.syntax = "OFF"
end
