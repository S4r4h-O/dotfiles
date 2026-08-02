local map = vim.keymap.set

local M = {}
M.select_cwd = function()
	local dirs = vim.fs.dir(vim.fn.getcwd(), {})
	local choices = { ".." }
	for name, type in dirs do
		if type == "directory" then
			table.insert(choices, name)
		end
	end
	vim.ui.select(choices, {
		prompt = "Select new cwd: ",
	}, function(choice, idx)
		if choice == nil then
			return
		end
		if idx == 1 then
      vim.schedule(M.select_cwd)
		end
		vim.cmd("silent! cd " .. choice)
	end)
end

map("n", "<leader>pc", M.select_cwd, { desc = "Change cwd" })
