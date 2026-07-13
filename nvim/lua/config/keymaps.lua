local utils = require("config.utils")
local map = vim.keymap.set

-- ============================================================================
-- DELETE OPERATIONS
-- ============================================================================

-- Delete lines (Alt+d followed by d)
map("n", "<A-d>d", '"_dd', { noremap = true, desc = "Delete current line in normal mode" })
map("v", "<A-d>d", '"_d', { noremap = true, desc = "Delete current line in visual mode" })
map("i", "<A-d>d", '"<Esc>_dd', { noremap = true, desc = "Delete current line in insert mode" })

-- Delete word (Alt+d followed by w)
map("n", "<A-d>w", '"_diw', { desc = "Delete current word in normal mode" })
map("v", "<A-d>w", '"_d"', { desc = "Delete selected word in visual mode" })
map("i", "<A-d>w", '"<Esc>_diw', { desc = "Delete current word in insert mode" })

-- Replace word
map("n", "ciw", '"_ciw', { desc = "Replace current word in normal mode" })

-- Delete all lines
map("n", "<A-d>a", '"_dG', { noremap = true, desc = "Delete all lines without affecting clipboard" })
map("n", "<A-d>l", '"_dd', { noremap = true, desc = "Delete current without affecting clipboard" })

map({ "n", "v" }, "s", '"_s')
map({ "n", "v" }, "S", '"_S')

-- ============================================================================
-- COPY/PASTE OPERATIONS
-- ============================================================================
map("n", "<C-y>", "<cmd>silent! %y<CR>", { desc = "Copy entire file" })

map("n", "<A-t>", function()
  vim.cmd('normal! diw"_xea p')
end, { desc = "" })

-- ============================================================================
-- DUPLICATE LINES
-- ============================================================================
map({ "n", "v" }, "<C-d>j", function()
  utils.duplicate_with_gap("down")
end, { desc = "Duplicate line/selection below (with gap)" })

map({ "n", "v" }, "<C-d>k", function()
  utils.duplicate_with_gap("up")
end, { desc = "Duplicate line/selection above (with gap)" })

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================
-- Select all
map("n", "<A-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("silent! write")
  if vim.bo.modified then
    vim.notify("Failed to save", vim.log.levels.ERROR)
  else
    vim.notify("File saved", vim.log.levels.INFO)
  end
end, { desc = "Save file" })

-- Remap VIM 0 to first non-blank character
map({ "n", "x", "o" }, "0", "^")

-- Move lines with Alt-j/k
map("n", "<A-j>", ":m .+1<CR>==", { silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true })

map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("x", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Move characters with Alt-h/l
map({ "n", "v" }, "<A-h>", function()
  if vim.fn.col(".") > 1 then
    vim.cmd.normal({ "xhP", bang = true })
  end
end)

map({ "n", "v" }, "<A-l>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if col < #line then
    vim.cmd.normal({ "xp", bang = true })
  end
end)

map({ "n", "i" }, "<leader>ft", "<cmd>FormatToggle<cr>", { desc = "Toggle Format ON/OFF" })

map("n", "Q", "gqq", { desc = "" })

-- Insert line above/down in INSERT mode
map("i", "<C-k>", "<C-o>O", { desc = "Insert line above when in insert mode" })
map("i", "<C-j>", "<C-o>o", { desc = "Insert lines below when in insert mode" })

-- ============================================================================
-- NAVIGATION
-- ============================================================================

-- Windows/panels
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>sv", "<C-w>v")
map("n", "<leader>sh", "<C-w>s")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>sx", "<cmd>close<CR>")

map("n", "<leader>qq", function()
  vim.cmd.qa()
end, { desc = "Close everything and quit" })

-- Bufferline
-- map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>")
-- map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>")
--
-- map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>")
-- map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>")

map("n", "<leader>bd", function()
  utils.close_all_bufs_but_cur()
end, { desc = "Close all buffers but the current" })

map("n", "bd", function()
  utils.close_buffer()
end, { desc = "Delete Buffer" })

map("n", "<C-x>", "<C-w>c", { noremap = true, desc = "Close current window" })

map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- Native Tabs
map("n", "<S-h>", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
map("n", "<S-l>", "<cmd>tabnext<CR>", { desc = "Next Tab" })

map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close Other Tabs" })

map("n", "<leader>tH", "<cmd>-tabmove<CR>", { desc = "Move Tab Left" })
map("n", "<leader>tL", "<cmd>+tabmove<CR>", { desc = "Move Tab Right" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Navigate while in insert mode - Some of these keybinding don't work
-- in all terminal emulators
map("i", "<C-n>", "<C-g>j", { desc = "Go to line below in insert mode" })
map("i", "<C-p>", "<C-g>k", { desc = "Go to line above in insert mode" })

map("i", "<C-h>", "<C-o>h", { desc = "Go to previous caracter while in insert mode" })
map("i", "<C-l>", "<C-o>l", { desc = "Go to previous caracter while in insert mode" })

map("i", "<C-,>", "<C-o>b", { desc = "Go to previous word in insert mode" })
map("i", "<C-.>", "<C-o>w", { desc = "Go to next word in insert mode" })
map("i", "<C-S->>", "<C-o>W", { desc = "Go to next WORD in insert mode" })
map("i", "<C-S-<>", "<C-o>B", { desc = "Go to previous WORD in insert mode" })

map("i", "<C-0>", "<C-o>^", { desc = "Go to beginning of line while in insert mode" })
map("i", "<C-S-$>", "<C-o>$", { desc = "Go the the end of the line while in insert mode" })
map("i", "<C-c>", '<C-o>"_cc', { desc = "Delete current line in insert mode" })

-- ============================================================================
-- Command-line
-- ============================================================================

map("n", "<leader>cw", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.feedkeys(":%s/" .. word .. "/")
end, { desc = "Start search and replace with word under cursor" })

-- ============================================================================
-- OTHERS
-- ============================================================================
map("n", "gl", "$", { noremap = true })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map("n", "<C-p>", "<C-x>", { desc = "Decrement a number" })

map("n", "<C-n>", "<C-a>", { desc = "Increment a number" })

map("n", "<leader>ct", function()
  utils.toggle()
end, { desc = "Invert true/false" })

map("n", "<leader>sg", function()
  local pattern = vim.fn.input("Grep something: ")
  if pattern == "" then
    return
  end
  vim.cmd("silent grep! " .. pattern)
  vim.cmd("copen")
end, { desc = "Dynamic grep" })

map("n", "<C-Space>", "?", { desc = "" })

-- Native terminal call. C-_ is C-/
vim.keymap.set("n", "<C-\\>", function()
  vim.cmd("botright 10split")
  vim.cmd("terminal")
end, { desc = "Open the terminal" })
