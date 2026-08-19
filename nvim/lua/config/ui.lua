local function set_transparent()
  local hl = vim.api.nvim_set_hl

  local accent = {
    normal = "#c0caf5",
    muted = "#a9b1d6",
    blue = "#7aa2f7",
    cyan = "#7dcfff",
    purple = "#bb9af7",
    border = "#565f89",
    separator = "#2a2f45",
    popup = "#1a1b26",
    popup_sel = "#283457",
  }

  local transparent_groups = {
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "ColorColumn",
  }

  for _, g in ipairs(transparent_groups) do
    hl(0, g, { bg = "none" })
  end

  hl(0, "Normal", { fg = accent.normal })
  hl(0, "NormalNC", { fg = accent.muted })
  hl(0, "EndOfBuffer", { fg = accent.separator })
  hl(0, "TabLine", { fg = accent.muted })
  hl(0, "TabLineFill", { fg = "none" })
  hl(0, "FloatBorder", { fg = accent.border, bg = accent.popup })
  hl(0, "NormalFloat", { fg = accent.normal, bg = accent.popup })
  hl(0, "Pmenu", { fg = accent.normal, bg = accent.popup })
  hl(0, "PmenuSbar", { bg = accent.popup })
  hl(0, "PmenuThumb", { bg = accent.border })
  hl(0, "LineNr", { bg = "none", fg = accent.border })
  hl(0, "FoldColumn", { bg = "none", fg = accent.border })
  hl(0, "Folded", { bg = "none", fg = accent.muted })
  hl(0, "VertSplit", { bg = "none", fg = accent.separator })
  hl(0, "WinSeparator", { bg = "none", fg = accent.separator })
  hl(0, "TabLineSel", { fg = accent.purple, bold = true })
  hl(0, "PmenuSel", { fg = accent.cyan, bg = accent.popup_sel, bold = true })
  hl(0, "CursorLineNr", { bg = "none", fg = accent.blue, bold = true })
end

set_transparent()

local last_key = ""

_G.mode = function()
  local modes = {
    n = "󰞷 NORMAL",
    i = "󰏫 INSERT",
    v = "󰈈 VISUAL",
    V = "󰈈 V-LINE",
    [""] = "󰈈 V-BLOCK",
    c = "󰘳 COMMAND",
    R = "󰑙 REPLACE",
    t = "󰆍 TERMINAL",
  }

  return modes[vim.fn.mode()] or vim.fn.mode()
end

_G.last_key = function()
  return last_key
end

_G.recording = function()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "󰑋 @" .. reg .. " | "
end

_G.curr_lsp = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local client = clients[1]

  if not client then
    return ""
  end
  return "󰒋 " .. client.name .. " | "
end

vim.on_key(function(key)
  last_key = vim.fn.keytrans(key)
  vim.schedule(function()
    vim.cmd("redrawstatus")
  end)
end)

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_set_hl(0, "MyStatusLeft", {
  link = "StatusLine",
})

vim.api.nvim_set_hl(0, "MyStatusRight", {
  link = "StatusLineNC",
})

vim.opt.statusline = table.concat({
  "%#MyStatusLeft#",
  " 󰉋 %{getcwd()} ",
  "%=",
  "%#MyStatusRight#",
  "%{v:lua.mode()} | ",
  "%{v:lua.recording()}",
  "%{v:lua.curr_lsp()}",
  "󰈙 %t %m%r| ",
  "%l:%c  ",
  "󰌌 %{v:lua.last_key()} ",
  "%*",
})
