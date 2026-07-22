if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-hidden --no-heading"
end

vim.g.lsp_inlay_hints_enabled = false

vim.filetype.add({ extension = { zsh = "zsh" } })

vim.opt.listchars = {
  tab = "│ ",
  leadtab = "│ ",
  leadmultispace = "│ ",
}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true

vim.opt.fillchars:append({ eob = " " })

vim.opt.clipboard = "unnamedplus"

vim.opt.laststatus = 2

-- TODO: I think i should move the statusline config
-- to somewhere else
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
  "󰈙 %t %m%r| ",
  "%l:%c  ",
  "󰌌 %{v:lua.last_key()} ",
  "%*",
})

vim.opt.autowriteall = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_user_command("ReloadConfig", function()
  local modules = {
    "config.options",
    "config.keymaps",
    "config.autocmds",
    "features.utils",
    "features.formatters",
    "features.lsp",
  }

  for _, module in ipairs(modules) do
    package.loaded[module] = nil
    require(module)
  end

  vim.notify("Cofiguration reloaded", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("ClearRegs", function()
  for r in string.gmatch([[abcdefghijklmnopqrstuvwxyz0123456789"/-*+]], ".") do
    vim.fn.setreg(r, "")
  end
end, {})

-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = false, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.shiftwidth = 2
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 100
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.cmdheight = 1

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
