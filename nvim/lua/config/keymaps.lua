local utils = require("config.utils")

-- ============================================================================
-- DELETE OPERATIONS
-- ============================================================================

-- Delete lines (Alt+d followed by d)
vim.keymap.set("n", "<A-d>d", '"_dd', { noremap = true, desc = "Delete current line in normal mode" })
vim.keymap.set("v", "<A-d>d", '"_d', { noremap = true, desc = "Delete current line in visual mode" })
vim.keymap.set("i", "<A-d>d", '"<Esc>_dd', { noremap = true, desc = "Delete current line in insert mode" })

-- Delete word (Alt+d followed by w)
vim.keymap.set("n", "<A-d>w", '"_diw', { desc = "Delete current word in normal mode" })
vim.keymap.set("v", "<A-d>w", '"_d"', { desc = "Delete selected word in visual mode" })
vim.keymap.set("i", "<A-d>w", '"<Esc>_diw', { desc = "Delete current word in insert mode" })

-- Replace word
vim.keymap.set("n", "ciw", '"_ciw', { desc = "Replace current word in normal mode" })

-- Delete all lines
vim.keymap.set("n", "<A-d>a", '"_dG', { noremap = true, desc = "Delete all lines without affecting clipboard" })
vim.keymap.set("n", "<A-d>l", '"_dd', { noremap = true, desc = "Delete current without affecting clipboard" })

vim.keymap.set({ "n", "v" }, "s", '"_s')
vim.keymap.set({ "n", "v" }, "S", '"_S')

-- ============================================================================
-- COPY/PASTE OPERATIONS
-- ============================================================================
vim.keymap.set("n", "<C-y>", '"+yy', { noremap = true, desc = "Copy entire line (normal mode)" })
vim.keymap.set("v", "<C-y>", '"+y', { noremap = true, desc = "Copy selection (visual mode)" })
vim.keymap.set("i", "<C-y>", '<Esc>"+yyi', { noremap = true, desc = "Copy entire line (insert mode)" })

-- ============================================================================
-- DUPLICATE LINES
-- ============================================================================
vim.keymap.set({ "n", "v" }, "<C-d>j", function()
  utils.duplicate_with_gap("down")
end, { desc = "Duplicate line/selection below (with gap)" })

vim.keymap.set({ "n", "v" }, "<C-d>k", function()
  utils.duplicate_with_gap("up")
end, { desc = "Duplicate line/selection above (with gap)" })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================
-- Select all
vim.keymap.set("n", "<A-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("silent! write")
  if vim.bo.modified then
    vim.notify("Failed to save", vim.log.levels.ERROR)
  else
    vim.notify("File saved", vim.log.levels.INFO)
  end
end, { desc = "Save file" })

-- Remap VIM 0 to first non-blank character
vim.keymap.set({ "n", "x", "o" }, "0", "^")

-- Move lines with Alt-j/k
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Move characters with Alt-h/l
vim.keymap.set("n", "<A-h>", function()
  if vim.fn.col(".") > 1 then
    vim.cmd.normal({ "xhP", bang = true })
  end
end)

vim.keymap.set("n", "<A-l>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if col < #line then
    vim.cmd.normal({ "xp", bang = true })
  end
end)

vim.keymap.set({ "n", "i" }, "<leader>ft", "<cmd>FormatToggle<cr>", { desc = "Toggle Format ON/OFF" })

-- ============================================================================
-- NAVIGATION
-- ============================================================================
-- Windows/panels
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
vim.keymap.set("n", "<leader>se", "<C-w>=")
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>")

vim.keymap.set("n", "<leader>qq", function()
  vim.cmd.qa()
end, { desc = "Close everything and quit" })

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>")

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>")
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>")

vim.keymap.set("n", "bd", function()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.cmd("bnext")

  if vim.api.nvim_get_current_buf() == bufnr then
    vim.cmd("enew")
  end

  vim.api.nvim_buf_delete(bufnr, {})
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<C-x>", "<C-w>c", { noremap = true, desc = "Close current window" })

-- ============================================================================
-- OTHERS
-- ============================================================================
vim.keymap.set("n", "gl", "$", { noremap = true })

vim.keymap.set("n", "<A-l>", function()
  vim.cmd("normal! xp")
end)

vim.keymap.set("v", "<A-l>", function()
  vim.cmd("normal! xp")
end)

vim.keymap.set("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end, { silent = true, desc = "Clear search highlight" })

vim.keymap.set("n", "<leader>sg", function()
  local pattern = vim.fn.input("Grep something: ")
  if pattern == "" then
    return
  end
  vim.cmd("silent grep! " .. pattern)
  vim.cmd("copen")
end, { desc = "Dynamic grep" })
