local map = vim.keymap.set

local C = {}

C.augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- vim.api.nvim_create_user_command("FormatToggle", function()
--   vim.g.autoformat = not vim.g.autoformat
--   vim.notify("Autoformat " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO)
-- end, {})
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
--   callback = function(args)
--     if not vim.g.autoformat or vim.b.autoformat == false then
--       return
--     end
--     vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 3000 })
--   end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }

    -- I'm using fzf.lua for some of these
    -- map("n", "gd", vim.lsp.buf.definition, opts)
    -- map("n", "gr", vim.lsp.buf.references, opts)
    -- map("n", "gD", vim.lsp.buf.declaration, opts)
    -- map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true, remap = true }

    -- close quickfix
    map("n", "q", "<cmd>close<CR>", opts)
    -- open file in a new buffer, closing quickfix
    map("n", "o", "<CR><cmd>cclose<CR>", opts)
    -- TODO: close quickfix for the splits?
    -- open file in horizontal split buffer
    map("n", "s", "<C-w><CR>", opts)
    -- open file in vertical split buffer
    map("n", "v", "<C-w><C-v><CR>", opts)
    -- open file in a new tab
    map("n", "t", function()
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

    map("n", "j", "<cmd>cnext<cr><cmd>wincmd p<cr>", {
      buffer = true,
      silent = true,
      desc = "Next Quickfix Item",
    })

    map("n", "k", "<cmd>cprev<cr><cmd>wincmd p<cr>", {
      buffer = true,
      silent = true,
      desc = "Previous Quickfix Item",
    })

    map("n", "n", "<cmd>cnext<cr>", {
      buffer = true,
      silent = true,
      desc = "Next Quickfix Item",
    })

    map("n", "N", "<cmd>cprev<cr>", {
      buffer = true,
      silent = true,
      desc = "Previous Quickfix Item",
    })

    vim.wo.cursorline = true
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = C.augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  group = C.augroup,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

return C
