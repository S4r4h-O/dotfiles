return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    config = function()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = {
          vim.fn.stdpath("config") .. "/lua/plugins/snippets",
        },
      })
    end,
  },
}
