local map = vim.keymap.set
local java = require("features.projects.java")

map("n", "<leader>pj", java.create_java_project, { desc = "Create Java project" })
