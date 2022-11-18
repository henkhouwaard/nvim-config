-- import telescope plugin safely
local telescope = require("telescope")
local actions = require("telescope.actions")

-- configure telescope
telescope.setup({
  -- configure custom mappings
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
      },
    },
  },
  extensions = {
    project = {
      base_dirs = {
        { "~/source", max_depth = 1 },
      },
    }
  },
})

telescope.load_extension("fzf")
telescope.load_extension("project")
telescope.load_extension("file_browser")
telescope.load_extension("projects")
