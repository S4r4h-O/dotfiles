return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      bashls = {
        filetypes = { "sh", "bash", "zsh" },
        settings = {
          bashIde = {
            globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
          },
        },
      },
    },
  },
}
