local M = {}

function M.setup()
  local moonfly = require("lualine.themes.moonfly")
  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = "moonfly",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
      always_divide_middle = true,
    },
  }
end

return M

