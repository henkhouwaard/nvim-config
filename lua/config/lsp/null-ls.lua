local M = {}

local null_ls = require "null-ls"
local formatting = null_ls.builtins.formatting -- to setup formatters

M.setup = function(on_attach)
  null_ls.setup {
    sources = {
      formatting.stylua, -- lua formatter
    },
    on_attach = on_attach,
  }
end

return M
