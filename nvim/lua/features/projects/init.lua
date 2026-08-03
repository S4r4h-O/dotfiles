local M = {}

M.java = require("features.projects.java")
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.java",
  callback = function(args)
    M.java.setup(args.buf)
  end,
})

-- KEYMAPS
require("features.projects.keymaps")

return M
