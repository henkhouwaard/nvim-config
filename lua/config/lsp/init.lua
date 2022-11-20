require("config.lsp.handlers").setup()
local configuration = require "config.lsp.configuration"
local options = require "config.lsp.options"
require("config.lsp.install").setup(configuration, options)
require("config.lsp.null-ls").setup(options.on_attach)
