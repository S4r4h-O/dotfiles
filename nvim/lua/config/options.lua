vim.g.autoformat = true

vim.opt.shortmess:append("I")

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-hidden --no-heading"
end

vim.g.lsp_inlay_hints_enabled = false

vim.filetype.add({ extension = { zsh = "zsh" } })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true

vim.opt.fillchars:append({ eob = " " })

vim.opt.clipboard = "unnamedplus"

vim.opt.autowriteall = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_user_command("ReloadConfig", function()
  local modules = {
    "config.options",
    "config.keymaps",
    "config.autocmds",
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
