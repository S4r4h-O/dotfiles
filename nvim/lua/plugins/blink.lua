local map = vim.keymap.set

return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",

  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },

  opts = {
    keymap = {
      preset = "default",
      ["<C-n>"] = {},
      ["<C-p>"] = {},
    },
    snippets = {
      expand = function(args)
        require("luasnip").lsp_expand(args)
      end,
    },

    sources = {
      default = {
        "lsp",
        "snippets",
      },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
        },
      },
    },

    completion = {
      menu = {
        auto_show = function(ctx)
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]

          local before_cursor = line:sub(1, col)
          return before_cursor:match("%w+$") ~= nil
        end,
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  },

  config = function(_, opts)
    local blink = require("blink.cmp")
    local ls = require("luasnip")

    blink.setup(opts)

    map({ "i", "s" }, "<Tab>", function()
      if blink.is_visible() then
        blink.select_next()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        return "<Tab>"
      end
    end, { expr = true })

    map({ "i", "s" }, "<S-Tab>", function()
      if blink.is_visible() then
        blink.select_prev()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        return "<S-Tab>"
      end
    end, { expr = true })

    map("i", "<CR>", function()
      if blink.is_visible() then
        blink.accept()
      else
        return "<CR>"
      end
    end, { expr = true })

    map("i", "<Esc>", function()
      if blink.is_visible() then
        blink.hide()
        return ""
      end

      if ls.in_snippet() then
        ls.unlink_current()
      end

      return "<Esc>"
    end, { expr = true })
  end,
}
