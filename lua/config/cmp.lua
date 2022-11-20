local M = {}

vim.o.completeopt = "menu,menuone,noselect"

local source_mapping = {
  nvim_lsp = "[Lsp]",
  luasnip = "[Snip]",
  buffer = "[Buffer]",
  nvim_lua = "[Lua]",
  treesitter = "[Tree]",
  path = "[Path]",
  rg = "[Rg]",
  nvim_lsp_signature_help = "[Sig]",
  -- cmp_tabnine = "[TNine]",
}

function M.setup()
  local luasnip = require "luasnip"
  local cmp = require "cmp"
  local lspkind = require "lspkind"
  local types = require "cmp.types"

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      -- ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-l>"] = cmp.mapping {
        i = function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end,
      },
      ["<C-u>"] = cmp.mapping {
        i = function(fallback)
          if luasnip.choice_active() then
            require "luasnip.extras.select_choice"()
          else
            fallback()
          end
        end,
      },
      -- ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping(function(fallback)
        cmp.close()
        cmp.mapping.close()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<CR>"] = cmp.mapping {
        i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
          else
            fallback()
          end
        end,
      },
      ["<C-j>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      -- ["<Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   elseif luasnip.expand_or_jumpable() then
      --     luasnip.expand_or_jump()
      --   elseif neogen.jumpable() then
      --     neogen.jump_next()
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end, {
      --   "i",
      --   "s",
      --   "c",
      -- }),
      ["<C-k>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      -- ["<S-Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif luasnip.jumpable(-1) then
      --     luasnip.jump(-1)
      --   elseif neogen.jumpable(true) then
      --     neogen.jump_prev()
      --   else
      --     fallback()
      --   end
      -- end, {
      --   "i",
      --   "s",
      --   "c",
      -- }),
      ["<C-y>"] = {
        i = cmp.mapping.confirm { select = true },
      },
      ["<C-n>"] = {
        i = cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Insert },
      },
      ["<C-p>"] = {
        i = cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Insert },
      },
    },
    -- sources for autocompletion
    sources = cmp.config.sources {
      { name = "nvim_lsp" }, -- lsp
      { name = "luasnip" }, -- snippets
      { name = "buffer" }, -- text within current buffer
      { name = "path" }, -- file system paths
      { name = "nvim_lsp_signature_help" },
    },
    -- configure lspkind for vs-code like icons
    formatting = {
      format = lspkind.cmp_format {
        maxwidth = 50,
        ellipsis_char = "...",
        before = function(entry, vim_item)
          vim_item.kind = lspkind.presets.default[vim_item.kind]

          local menu = source_mapping[entry.source.name]
          vim_item.menu = menu
          return vim_item
        end,
      },
    },
  }

  -- Use buffer source for `/`
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Auto pairs
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

return M
