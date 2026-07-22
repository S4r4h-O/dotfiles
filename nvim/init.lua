vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
require("config.ui")
require("features.formatters")
require("features.term")
require("features.lsp")
