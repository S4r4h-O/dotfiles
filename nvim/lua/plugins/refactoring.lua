return {
  {
    "lewis6991/async.nvim",
    lazy = true,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      { "<leader>cr", "", mode = { "n", "x" }, desc = "+refactor" },

      {
        "<leader>crs",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Select Refactor",
      },

      {
        "<leader>cri",
        function()
          return require("refactoring").inline_var()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Inline Variable",
      },

      {
        "<leader>crf",
        function()
          return require("refactoring").extract_func()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Extract Function",
      },

      {
        "<leader>crF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Extract Function To File",
      },

      {
        "<leader>crx",
        function()
          return require("refactoring").extract_var()
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Extract Variable",
      },

      {
        "<leader>crP",
        function()
          return require("refactoring.debug").print_loc({
            output_location = "below",
          })
        end,
        expr = true,
        desc = "Debug Print Location",
      },

      {
        "<leader>crp",
        function()
          return require("refactoring.debug").print_var({
            output_location = "below",
          }) .. "iw"
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Debug Print Variable",
      },

      {
        "<leader>crc",
        function()
          return require("refactoring.debug").cleanup({
            restore_view = true,
          }) .. "ag"
        end,
        desc = "Debug Cleanup",
      },
    },
  },
}
