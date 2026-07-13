local utils = require("config.utils")

vim.g.autoformat = true

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformat " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO)
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
  callback = function(args)
    if not vim.g.autoformat or vim.b.autoformat == false then
      return
    end
    vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 3000 })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true, remap = true }

    -- close quickfix
    vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
    -- open file in a new buffer, closing quickfix
    vim.keymap.set("n", "o", "<CR><cmd>cclose<CR>", opts)
    -- TODO: close quickfix for the splits?
    -- open file in horizontal split buffer
    vim.keymap.set("n", "s", "<C-w><CR>", opts)
    -- open file in vertical split buffer
    vim.keymap.set("n", "v", "<C-w><C-v><CR>", opts)
    -- open file in a new tab
    vim.keymap.set("n", "t", function()
      -- uncomment if you want to close the quickfix after
      -- selecting a file
      -- local qf_win = vim.api.nvim_get_current_win()

      vim.cmd.tabnew()
      vim.cmd.cc()

      -- if vim.api.nvim_win_is_valid(qf_win) then
      --   vim.api.nvim_win_call(qf_win, function()
      --     vim.cmd.cclose()
      --   end)
      -- end
    end, { buffer = args.buf })

    vim.wo.cursorline = true
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})
