return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
      settings = {
        bashIde = {
          globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
        },
      },
    })

    vim.lsp.enable("bashls")
  end,
}
