local utils = require("config.utils")
local map = vim.keymap.set

-- ============================================================================
-- FILE & SESSION OPERATIONS
-- ============================================================================
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.cmd("silent! write")
  if vim.bo.modified then
    vim.notify("Failed to save", vim.log.levels.ERROR)
  else
    vim.notify("File saved", vim.log.levels.INFO)
  end
end, { desc = "Save file" })

map("n", "<leader>fn", function()
  local file = vim.fn.input("File: ")
  if file ~= "" then
    vim.cmd.edit(vim.fn.fnameescape(file))
  end
end, { desc = "New File" })

map("n", "<leader>qq", function()
  vim.cmd.qa()
end, { desc = "Close everything and quit" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<C-Up>", "<C-w>+", { desc = "Increase window height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease window height" })
map("n", "<C-Left>", "<C-w><", { desc = "Decrease window width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase window width" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
map("n", "<C-x>", "<C-w>c", { noremap = true, desc = "Close current window" })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })

map("n", "bd", function()
  utils.close_buffer()
end, { desc = "Delete Buffer" })

-- ============================================================================
-- NAVIGATION
-- ============================================================================
-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Line navigation
map({ "n", "x", "o" }, "0", "^", { desc = "Move to first non-blank character" })
map("n", "gl", "$", { noremap = true, desc = "Move to end of line" })

-- ============================================================================
-- SEARCH & GREP
-- ============================================================================
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  vim.cmd("nohlsearch")
  if vim.snippet then
    vim.snippet.stop()
  end
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map("n", "<leader>sg", function()
  local pattern = vim.fn.input("Grep something: ")
  if pattern == "" then
    return
  end
  vim.cmd("silent grep! " .. pattern)
  vim.cmd("copen")
end, { desc = "Dynamic grep" })

-- Saner behavior of n and N
map("n", "n", "'nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nn'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nn'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nn'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- ============================================================================
-- TEXT MANIPULATION & MOVEMENT
-- ============================================================================
-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selection up" })

-- Move characters
map("n", "<A-h>", function()
  if vim.fn.col(".") > 1 then
    vim.cmd.normal({ "xhP", bang = true })
  end
end, { desc = "Move character left" })

map("n", "<A-l>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if col < #line then
    vim.cmd.normal({ "xp", bang = true })
  end
end, { desc = "Move character right" })

map("v", "<A-l>", function()
  vim.cmd("normal! xp")
end, { desc = "Move selection right" })

map("v", "<A-h>", function()
  vim.cmd("normal! xhP")
end, { desc = "Move selection right" })

-- Values manipulation
map("n", "<C-n>", "<C-x>", { desc = "Decrement a number" })
map("n", "<C-m>", "<C-a>", { desc = "Increment a number" })
map("n", "<leader>ct", function()
  utils.toggle()
end, { desc = "Invert true/false" })

-- ============================================================================
-- SELECTION, COPY & DUPLICATE
-- ============================================================================
map("n", "<A-a>", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

map("n", "<C-y>", '"+yy', { noremap = true, desc = "Copy entire line (normal mode)" })
map("v", "<C-y>", '"+y', { noremap = true, desc = "Copy selection (visual mode)" })
map("i", "<C-y>", '<Esc>"+yyi', { noremap = true, desc = "Copy entire line (insert mode)" })

map({ "n", "v" }, "<C-d>j", function()
  utils.duplicate_with_gap("down")
end, { desc = "Duplicate line/selection below (with gap)" })

map({ "n", "v" }, "<C-d>k", function()
  utils.duplicate_with_gap("up")
end, { desc = "Duplicate line/selection above (with gap)" })

-- ============================================================================
-- DELETE & REPLACE OPERATIONS
-- ============================================================================
-- Delete lines (Alt+d followed by d)
map("n", "<A-d>d", '"_dd', { noremap = true, desc = "Delete current line in normal mode" })
map("v", "<A-d>d", '"_d', { noremap = true, desc = "Delete current line in visual mode" })
map("i", "<A-d>d", '"<Esc>_dd', { noremap = true, desc = "Delete current line in insert mode" })

-- Delete word (Alt+d followed by w)
map("n", "<A-d>w", '"_diw', { desc = "Delete current word in normal mode" })
map("v", "<A-d>w", '"_d"', { desc = "Delete selected word in visual mode" })
map("i", "<A-d>w", '"<Esc>_diw', { desc = "Delete current word in insert mode" })

-- Replace/Substitute
map("n", "ciw", '"_ciw', { desc = "Replace current word in normal mode" })
map({ "n", "v" }, "s", '"_s', { desc = "Substitute character without clipboard" })
map({ "n", "v" }, "S", '"_S', { desc = "Substitute line without clipboard" })

-- Other delete operations
map("n", "<A-d>a", function()
  vim.cmd("%delete _")
end, {
  desc = "Delete all lines without affecting clipboard",
})
map("n", "<A-d>l", '"_dd', { noremap = true, desc = "Delete current without affecting clipboard" })

-- ============================================================================
-- UI & TOOLS
-- ============================================================================
map({ "n", "i" }, "<leader>ft", "<cmd>FormatToggle<cr>", { desc = "Toggle Format ON/OFF" })

map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })
