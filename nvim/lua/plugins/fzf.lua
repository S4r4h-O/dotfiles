return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Navegação dentro do FZF
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"

      config.defaults.keymap.builtin["<C-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<C-b>"] = "preview-page-up"

      return {
        "telescope",

        fzf_colors = true,

        fzf_opts = {
          ["--no-scrollbar"] = true,
        },

        defaults = {
          formatter = "path.dirname_first",
        },

        winopts = {
          width = 0.85,
          height = 0.80,
          preview = {
            layout = "vertical",
            vertical = "down:45%",
            scrollchars = { "┃", "" },
          },
        },

        files = {
          cwd_prompt = false,
          actions = {
            ["alt-h"] = { actions.toggle_hidden },
            ["alt-i"] = { actions.toggle_ignore },
          },
        },

        grep = {
          actions = {
            ["alt-h"] = { actions.toggle_hidden },
            ["alt-i"] = { actions.toggle_ignore },
          },
        },
      }
    end,

    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,

    keys = {
      { "<leader><space>", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>,", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>/", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },

      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },

      { "<leader>sh", "<cmd>FzfLua help_tags<CR>", desc = "Help" },
      { "<leader>sk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
      { "<leader>sc", "<cmd>FzfLua commands<CR>", desc = "Commands" },

      { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_document<CR>", desc = "Buffer diagnostics" },

      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Workspace symbols" },

      { "gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "Goto definition" },
      { "gr", "<cmd>FzfLua lsp_references<CR>", desc = "Goto references" },
      { "gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "Goto implementation" },
      { "gt", "<cmd>FzfLua lsp_typedefs<CR>", desc = "Goto type definition" },
    },
  },
}
