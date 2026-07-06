return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",

  dependencies = {
    "nvimtools/hydra.nvim",
  },

  opts = {},

  cmd = {
    "MCstart",
    "MCvisual",
    "MCclear",
    "MCpattern",
    "MCvisualPattern",
    "MCunderCursor",
  },

  keys = {
    {
      "mm",
      "<cmd>MCstart<CR>",
      mode = { "n", "v" },
      desc = "Multicursor: Start",
    },
    {
      "mM",
      "<cmd>MCunderCursor<CR>",
      mode = "n",
      desc = "Multicursor: Character",
    },
    {
      "mp",
      "<cmd>MCpattern<CR>",
      mode = "n",
      desc = "Multicursor: Pattern",
    },
    {
      "mp",
      "<cmd>MCvisualPattern<CR>",
      mode = "v",
      desc = "Multicursor: Pattern in Selection",
    },
    {
      "mv",
      "<cmd>MCvisual<CR>",
      mode = "v",
      desc = "Multicursor: Visual Selection",
    },
    {
      "md",
      "<cmd>MCclear<CR>",
      mode = "n",
      desc = "Multicursor: Clear",
    },
  },
}
