-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================
local M = {}

-- Duplicate lines function
-- @param direction string: "up" or "down"
-- @param gap boolean: add empty line between original and duplicate
M.duplicate_with_gap = function(direction)
  local is_v = vim.fn.mode():find("[vV\22]")
  local s, e = vim.fn.line(is_v and "v" or "."), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end

  local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  local count = #lines

  if direction == "down" then
    table.insert(lines, 1, "")
    vim.api.nvim_buf_set_lines(0, e, e, false, lines)
    if is_v then
      vim.fn.setpos("'<", { 0, e + 2, 0, 0 })
      vim.fn.setpos("'>", { 0, e + 1 + count, 0, 0 })
      vim.cmd("normal! gv")
    else
      vim.api.nvim_win_set_cursor(0, { e + 2, 0 })
    end
  else
    table.insert(lines, "")
    vim.api.nvim_buf_set_lines(0, s - 1, s - 1, false, lines)
    if is_v then
      vim.fn.setpos("'<", { 0, s, 0, 0 })
      vim.fn.setpos("'>", { 0, s + count - 1, 0, 0 })
      vim.cmd("normal! gv")
    else
      vim.api.nvim_win_set_cursor(0, { s, 0 })
    end
  end
end

M.toggle = function()
  local word = vim.fn.expand("<cword>")
  if word == "true" then
    vim.cmd("normal! ciwfalse")
  elseif word == "false" then
    vim.cmd("normal! ciwtrue")
  else
    return
  end
end

M.close_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.cmd("bnext")

  if vim.api.nvim_get_current_buf() == bufnr then
    vim.cmd("enew")
  end

  vim.api.nvim_buf_delete(bufnr, {})
end

return M
