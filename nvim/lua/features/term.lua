-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false,
}

local function close_terminal()
  if terminal_state.is_open
      and terminal_state.win
      and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

local function create_terminal_buffer()
  terminal_state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[terminal_state.buf].bufhidden = "hide"

  vim.api.nvim_create_autocmd("TermOpen", {
    buffer = terminal_state.buf,
    once = true,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
    end,
  })

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = terminal_state.buf,
    callback = function()
      if vim.v.event.status == 0 and vim.api.nvim_buf_is_valid(terminal_state.buf) then
        vim.api.nvim_buf_delete(terminal_state.buf, {})
        terminal_state.buf = nil
      end
    end,
  })
end

local function FloatingTerminal()
  if terminal_state.is_open then
    close_terminal()
    return
  end

  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    create_terminal_buffer()
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  vim.wo[terminal_state.win].winblend = 0
  vim.wo[terminal_state.win].winhighlight =
    "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"

  if vim.bo[terminal_state.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.env.SHELL)
  end

  terminal_state.is_open = true
  vim.cmd.startinsert()

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    once = true,
    callback = close_terminal,
  })
end

vim.keymap.set("n", "<A-t>", FloatingTerminal, {
  desc = "Toggle floating terminal",
  silent = true,
})

vim.keymap.set("t", "<A-t>", close_terminal, {
  desc = "Close floating terminal",
  silent = true,
})
