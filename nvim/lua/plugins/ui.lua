return {
  -- {
  --   "akinsho/bufferline.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     { "<leader>bd", "<cmd>BufferLinePickClose<cr>", desc = "Toggle Pin" },
  --     { "bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
  --     { "bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
  --     { "br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
  --     { "bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
  --     { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
  --     { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  --     { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
  --     { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  --     { "bj", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
  --   },
  --   opts = {
  --     options = {
  --       close_command = function(n)
  --         vim.api.nvim_buf_delete(n, { force = true })
  --       end,
  --       right_mouse_command = function(n)
  --         vim.api.nvim_buf_delete(n, { force = true })
  --       end,
  --       diagnostics = "nvim_lsp",
  --       always_show_bufferline = false,
  --       offsets = {
  --         { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" },
  --       },
  --     },
  --   },
  -- },

  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "nvim-mini/mini.icons",
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        return require("mini.icons").mock_nvim_web_devicons()
      end
    end,
  },
}
