local utils = require("config.utils")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 3000 })
  end,
})
