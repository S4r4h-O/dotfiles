return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "insertenter", "cmdlineenter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      snippets = {
        -- opts = {},
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
        },
        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
        },
      },

      keymap = {
        preset = "enter",
        ["<c-y>"] = { "select_and_accept" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },
}
