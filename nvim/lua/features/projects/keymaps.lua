local map = vim.keymap.set

local java = require("features.projects.java")

local python = require("features.projects.python")

map("n", "<leader>pj", java.create_java_project, { desc = "Create Java project" })
map("n", "<leader>pp", python.create_uv_project, { desc = "Create uv project" })
