vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
require("utils.formatters")
require("utils.term")
require("utils.lsp")
require("config.ui")
