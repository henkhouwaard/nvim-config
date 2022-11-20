local M = {}
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local info = require("utils").info

local on_attach = function(client, bufnr)
  require("config.lsp.keymaps").setup(client, bufnr)

  local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format {
        async = false,
        filter = M.filter,
      }
    end,
  })
end

function M.filter(client)
  if M.nullavailable() then
    local f = client.name == "null-ls"
    if f then
      info("Format using: " .. client.name)
      return true
    end
  else
    info("Format using: " .. client.name)
    return true
  end
end

function M.nullavailable()
  local clients = vim.lsp.get_active_clients()
  for _, c in ipairs(clients) do
    if c.name == "null-ls" then
      return true
    end
  end
  return false
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
