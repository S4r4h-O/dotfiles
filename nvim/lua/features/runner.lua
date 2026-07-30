-- This module still is very rudimentar
local map = vim.keymap.set

local file_runners = {
  python = function(fname)
    return { "python3", fname }
  end,

  lua = function(fname)
    return { "lua", fname }
  end,

  javascript = function(fname)
    return { "deno", fname }
  end,

  -- TODO: compile before running?
  typescript = function(fname)
    return { "deno", fname }
  end,

  sh = function(fname)
    return { "bash", fname }
  end,

  java = function(fname)
    local classname = vim.fs.basename(fname):gsub("%.java$", "")
    return {
      "sh",
      "-c",
      string.format("javac %s && java %s", fname, classname),
    }
  end,
}

local state = {
  job = nil,
  pid = nil,
  buf = nil,
  win = nil,
}

vim.api.nvim_create_user_command("Run", function()
  local fname = vim.api.nvim_buf_get_name(0)
  local ftype = vim.bo.filetype
  local runner = file_runners[ftype]

  if not runner then
    vim.notify("No runner found for filetype " .. ftype, vim.log.levels.ERROR)
    return
  end

  if state.job then
    vim.notify(
      "Already running "
        .. fname
        .. ", use RestartRun if you want to restart the job or StopRun.",
      vim.log.levels.ERROR
    )
    return
  end

  state.buf = vim.api.nvim_create_buf(true, true)

  vim.api.nvim_buf_set_name(state.buf, "Runner")

  vim.cmd(":vsplit")
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)

  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].bufhidden = "wipe"
  vim.bo[state.buf].swapfile = false

  state.job = vim.fn.jobstart(runner(fname), {
    term = true,
    on_exit = function()
      vim.schedule(function()
        for k in pairs(state) do
          state[k] = nil
        end
      end)
    end,
  })

  state.pid = vim.fn.jobpid(state.job)
end, {})

vim.api.nvim_create_user_command("StopRun", function()
  if not state.job then
    vim.notify("No jobs running", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstop(state.job)
  state.job = nil
end, {})

vim.api.nvim_create_user_command("RestartRun", function()
  if not state.job then
    vim.notify("No jobs running", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_win_close(state.win, true)
  vim.cmd("StopRun")
  vim.cmd("Run")
end, {})

-- TODO:
-- - [ ] run project
-- - [ ] run java project
-- - [ ] toggle runner visibility?
-- - [ ] run more than one file
map("n", "<leader>rr", ":Run<CR>", { desc = "Run current file" })
map("n", "<leader>rs", ":StopRun<CR>", { desc = "Stop current job" })
map("n", "<leader>ra", ":RestartRun<CR>", { desc = "Restart current job" })
