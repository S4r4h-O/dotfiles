local map = vim.keymap.set
local g = vim.g
local utils = require("features.utils")

g.netrw_clipboard = 0
g.netrw_fastbrowse = 2
g.netrw_markfile = "●"

-- g.netrw_liststyle = 0 -- Thin listing
-- g.netrw_liststyle = 1 -- Long listing
-- g.netrw_liststyle = 2 -- Wide listing
g.netrw_liststyle = 3 -- Tree view

g.netrw_browse_split = 0 -- default
-- g.netrw_browse_split = 1  -- horizontal split
-- g.netrw_browse_split = 2  -- vertical split
-- g.netrw_browse_split = 3  -- new tab
-- g.netrw_browse_split = 4  -- use previous windows

g.netrw_keepdir = 0
g.netrw_localcopydircmd = "cp -r"
g.netrw_altv = 1
g.netrw_alto = 1

g.netrw_liststyle = 3
g.netrw_sort_sequence = [[[\/]$,\*]]
g.netrw_preview = 1

-- g.netrw_banner=0
-- Remove all empty "No Name" buffers that are unmodified
local function clean_empty_bufs()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_get_name(buf) == ""
      and not vim.api.nvim_buf_get_option(buf, "modified")
      and vim.api.nvim_buf_is_loaded(buf)
    then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end

-- Clean up Netrw's empty buffer artifacts and let that logic toggle it
local function toggle_netrw()
  clean_empty_bufs()
  local flag = false
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local e, v = pcall(function()
      return vim.api.nvim_buf_get_var(buf, "current_syntax")
    end)
    if
      (e and v == "netrwlist")
      and not vim.api.nvim_buf_get_option(buf, "modified")
      and vim.api.nvim_buf_is_loaded(buf)
    then
      flag = true
      vim.api.nvim_buf_delete(buf, {})
    end
  end

  if not flag then
    vim.cmd("30Lex")
  end
end

local function refresh_netrw()
  toggle_netrw()
  toggle_netrw()
end

map("n", "<leader>ne", function()
  utils.toggle_netrw()
end, { desc = "Toggle netrw" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(args)
    vim.api.nvim_set_hl(0, "netrwMarkFile", {
      bold = true,
      underline = true,
    })
    map("n", "v", "mf", { remap = true, buffer = true })

    map("n", "d", "D", { remap = true, buffer = true })

    -- TODO: does not work with duplicated dirs
    -- This does not work as intented, I'm going crazy
    map("n", "a", function()
      local fname = vim.fn.input("Enter filename (dirs end with a '/'): ")

      if fname == "" then
        return
      end

      if string.match(fname, "^/?(.+)/$") then
        vim.fn.mkdir(fname, "-p")
      else
        local path, file = fname:match("^/?(.-)/([^/]+)$")
        if path then
          path = vim.fn.expand("%:p:h") .. "/" .. path
          vim.fn.mkdir(path, "-p")
          vim.fn.writefile({}, vim.fs.joinpath(path, file))
        else
          file = vim.fn.expand("%:p:h") .. "/" .. fname
          vim.fn.writefile({}, file)
        end
      end

      refresh_netrw()
    end, { buffer = true, silent = true })

    map("n", "<C-y>", function()
      local path = utils.get_abs_path()
      vim.fn.setreg("+", path)
      vim.notify("Path " .. path .. " copied.", vim.log.levels.INFO)
    end, {})
  end,
})
