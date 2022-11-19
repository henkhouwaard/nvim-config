local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      threshold = 0,
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    use "bluz71/vim-moonfly-colors"

    use {
      "goolord/alpha-nvim",
      config = function()
        require("config.splash").setup()
      end,
    }

    use {
      "TimUntersberger/neogit",
      requires = { "nvim-lua/plenary.nvim" },
      cmd = "Neogit",
      config = function()
        require("config.neogit").setup()
      end,
    }

    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
      end,
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    }

    -- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Better Comment
    use {
      "numToStr/Comment.nvim",
      opt = true,
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("Comment").setup {}
      end,
    }

    -- Status Line
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = function()
        require("config.lualine").setup()
      end,
      requires = { "nvim-web-devicons" },
    }

    -- Nvim Tree
    use {
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      cmd = { "NvimTreeToggle", "NvimTreeClose" },
      config = function()
        require("config.nvimtree").setup()
      end,
    }

    -- Buffer Line
    use {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      requires = { "nvim-web-devicons" },
      config = function()
        require("config.bufferline").setup()
      end,
    }

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        {
          "ahmedkhalf/project.nvim",
          config = function()
            require("project_nvim").setup {}
          end,
        },
      },
      config = function()
        require "config.telescope"
      end,
    }

    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-calc",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-emoji",
        "rafamadriz/friendly-snippets",
        {
          "onsails/lspkind.nvim",
          module = { "lspkind" },
        },
        {
          "L3MON4D3/LuaSnip",
          module = { "luasnip" },
          config = function()
            require("config.luasnip").setup()
          end,
        },
      },
      config = function()
        require("config.cmp").setup()
      end,
    }

    -- Managing and installing lsp servers, linters and formatters
    use {
      "williamboman/mason.nvim",
      requires = {
        "williamboman/mason-lspconfig.nvim",
        "jayp0521/mason-null-ls.nvim",
        {
          "jose-elias-alvarez/null-ls.nvim",
          config = function()
            require "config.lsp.null-ls"
          end,
        },
      },
      config = function()
        require("config.lsp.mason").setup()
      end,
    }

    -- Configure lsp client
    use {
      "neovim/nvim-lspconfig",
      requires = {
        {
          "hrsh7th/cmp-nvim-lsp",
          module = "cmp_nvim_lsp",
        },
        {
          "glepnir/lspsaga.nvim",
          branch = "main",
          config = function()
            require "config.lsp.lspsaga"
          end,
        },
        "jose-elias-alvarez/typescript.nvim",
      },
      config = function()
        require "config.lsp.lspconfig"
      end,
    }
    -- Auto pairs
    use {
      "windwp/nvim-autopairs",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }

    -- Auto tag
    use {
      "windwp/nvim-ts-autotag",
      requires = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    }

    -- End wise
    use {
      "RRethy/nvim-treesitter-endwise",
      requires = "nvim-treesitter",
      event = "InsertEnter",
      disable = false,
    }

    -- Tree sitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
      end,
      config = function()
        require("config.treesitter").setup()
      end,
    }

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"

  packer.init(conf)
  packer.startup(plugins)
end

return M
