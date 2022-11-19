local cmp_nvim_lsp = require "cmp_nvim_lsp"

local on_attach = function(client, bufnr)
  require("config.lsp.keymaps").setup(client, bufnr)
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
