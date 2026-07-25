local map = vim.keymap.set

local usr_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = usr_group,
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
  group = usr_group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  group = usr_group,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = usr_group,
  pattern = {
    "help",
    "man",
    "lspinfo",
    "checkhealth",
    "qf",
  },
  callback = function(args)
    map("n", "q", "<cmd>close<CR>", {
      buffer = args.buf,
      silent = true,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = usr_group,
  pattern = "netrw",
  callback = function(ev)
    local opts = {
      buffer = ev.buf,
      remap = true,
    }

    map("n", "<C-h>", "<C-w>h", opts)
    map("n", "<C-l>", "<C-w>l", opts)
    map("n", "<C-j>", "<C-w>j", opts)
    map("n", "<C-k>", "<C-w>k", opts)

    map("n", "<Tab>", "mf", opts) -- mark file
    map("n", "yy", "mc", opts) -- copy marked file
    map("n", "M", "mm", opts) -- move marked file
    map("n", "yp", function()
      local path = vim.fn.expand("<cfile>")
      vim.fn.setreg("+", vim.fn.fnamemodify(path, ":p"))
    end, { noremap = true, buffer = ev.buf, desc = "Copy file path" })

    map("n", ".", "gh", opts) -- toggle hidden

    map("n", "<C-a>", "%", opts) -- create file
    map("n", "<C-d>", "d", opts) -- create dir
  end,
})
