local M = {}

function M.setup(lspobjects, options)
  require("neodev").setup {}

  -- enable mason
  require("mason").setup()

  require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(lspobjects.servers),
    automatic_installation = false,
  }

  require("mason-null-ls").setup {
    ensure_installed = vim.tbl_keys(lspobjects.formatters),
    automatic_installation = false,
  }

  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local opts = vim.tbl_deep_extend("force", options, lspobjects.servers[server_name] or {})
      require("lspconfig")[server_name].setup(opts)
    end,
  }
end

return M
