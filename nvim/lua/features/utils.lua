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

M.lazygit = function()
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = "rounded",
    style = "minimal",
    title = " LazyGit ",
    title_pos = "center",
  })

  vim.fn.termopen("lazygit", {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  vim.cmd.startinsert()
end

M.file_exists = function(file)
  local f = io.open(file, "r")
  if f then
    f:close()
  end
  return f ~= nil
end

M.lines_from = function(file)
  if not M.file_exists(file) then
    return {}
  end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

M.split_str = function(inputstr, separator)
  if separator == nil then
    separator = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. separator .. "]+)") do
    table.insert(t, str)
  end
  return t
end

--TODO: move to ui
M.close_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.cmd("bnext")

  if vim.api.nvim_get_current_buf() == bufnr then
    vim.cmd("enew")
  end

  vim.api.nvim_buf_delete(bufnr, {})
end

M.close_all_bufs_but_cur = function()
  local current = vim.api.nvim_get_current_buf()
  local bufnrs = {}

  for _, buf in ipairs(vim.fn.getbufinfo()) do
    if buf.bufnr ~= current then
      table.insert(bufnrs, buf.bufnr)
    end
  end

  if #bufnrs > 0 then
    for _, buf in pairs(bufnrs) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

M.close_all_bufs = function()
  local bufnrs = {}

  for _, buf in ipairs(vim.fn.getbufinfo()) do
    table.insert(bufnrs, buf.bufnr)
  end

  if #bufnrs > 0 then
    for _, buf in pairs(bufnrs) do
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

M.toggle_netrw = function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd("cd %:p:h | if expand('%') !=# '' | w | endif | 30Lex")
end

M.get_abs_path = function()
  local path = vim.fn.expand("<cfile>")

  if path == "" then
    return
  end

  if vim.fn.isdirectory(path) then
    print("Path is dir")
  else
    print("Path is not dir")
  end

  return vim.fs.abspath(path)
end

M.get_file_dir = function(path)
  return path:match("(.*/)")
end

M.table_contains_v = function(table, val)
  for _, value in pairs(table) do
    if value == val then
      return true
    end
  end
  return false
end

M.table_contains_k = function(table, key)
  for k, _ in pairs(table) do
    if k == key then
      return true
    end
  end
  return false
end

M.table_len = function(table)
  local len = 0
  for _ in pairs(table) do
    len = len + 1
  end
  return len
end

-- Examples:
-- ```lua
-- utils.select_many({ "Item 1", "Item 2", "Item 3" }, "Select item(s)")
-- ```
-- 1. Item 1
-- 2. Item 2
-- 3. Item 3
-- Select item(s) (Esc to finish):

---@generic T
---@param items T[]
---@param prompt string
---@param label_func nil|fun(item: T): string
---@return table|nil
M.select_many = function(items, prompt, label_func)
  if not items or #items == 0 then
    return {}
  end
  label_func = label_func or function(item)
    return item
  end
  local selected = {}
  local choices = {}
  for index, item in ipairs(items) do
    local label = label_func(item)
    local choice = string.format("%s. %s", index, label)
    table.insert(choices, choice)
  end

  local answer = vim.fn.input(("\n%s\n%s (Esc to finish): "):format(table.concat(choices, "\n"), prompt))
  if not answer or answer == "" then
    return
  end

  local base_pattr = "%s*(%d+)%s*"
  local range_pttr = base_pattr .. "%-" .. base_pattr
  if not answer:match(base_pattr) and not answer:match(range_pttr) then
    vim.notify("Invalid, must enter a range (e.g 1-3, 1-2, 3...)", vim.log.levels.ERROR)
    return
  end

  local range_start, range_end = answer:match(range_pttr)

  if range_start then
    range_start = math.max(1, tonumber(range_start))
    range_end = math.min(#items, tonumber(range_end) or range_end)

    if range_start > range_end then
      vim.notify("Invalid, start must not be greater than end", vim.log.levels.ERROR)
      return
    end

    for i = range_start, range_end do
      table.insert(selected, items[i])
    end
  elseif answer:match(base_pattr .. "%-$") or answer:match("^%-" .. base_pattr) then
    vim.notify("Invalid range: " .. answer, vim.log.levels.ERROR)
    return
  else
    local index = math.min(#items, tonumber(answer))
    table.insert(selected, items[index])
    print(type(answer))
  end

  return selected
end

M.gen_random_indentifier = function(value)
  return value .. "-" .. vim.uv.hrtime()
end

---@param bufname string name of the floating window buffer
---@param cmd string[] list of strings (e.g {"python", "-m", "some_module", "args"})
---@param close_after_run nil|boolean wheter to close automatically or not
---@param sleep_before_close nil|integer seconds to wait before closing
---@param on_run_success nil|fun(source_buf: integer): nil original buffer is passed to the callback
M.floating_window_run = function(bufname, cmd, close_after_run, sleep_before_close, on_run_success)
  local source_buf = vim.api.nvim_get_current_buf()

  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_buf_set_name(buf, M.gen_random_indentifier(bufname))

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
  })

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to run " .. vim.inspect(cmd), vim.log.levels.ERROR)
        return
      end

      if close_after_run then
        if sleep_before_close then
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, {})
            end
          end, sleep_before_close)
        end
        vim.api.nvim_buf_delete(buf, {})
      end

      if on_run_success then
        on_run_success(source_buf)
      end
    end,
  })
end

return M
