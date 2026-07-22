vim.g.autoformat = false

local formatters = {
  python = {
    { "ruff", "format" },
  },

  lua = {
    { "stylua" },
  },

  sh = {
    { "shfmt", "-w" },
  },
  bash = {
    { "shfmt", "-w" },
  },
  zsh = {
    { "shfmt", "-w" },
  },

  c = {
    { "clang-format", "-i" },
  },
  cpp = {
    { "clang-format", "-i" },
  },

  java = {
    { "google-java-format", "--replace" },
  },

  javascript = {
    { "prettier", "--write" },
  },
  typescript = {
    { "prettier", "--write" },
  },

  json = {
    { "prettier", "--write" },
  },

  html = {
    { "prettier", "--write" },
  },

  css = {
    { "prettier", "--write" },
  },

  markdown = {
    { "prettier", "--write" },
  },

  rust = {
    { "rustfmt" },
  },

  go = {
    { "gofmt", "-w" },
  },

  kotlin = {
    { "ktfmt" },
  },

  toml = {
    { "taplo", "format" },
  },
}

local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ft = vim.bo[bufnr].filetype
  local formatter = formatters[ft]

  if not formatter then
    vim.notify(("No formatter configured for '%s'"):format(ft), vim.log.levels.WARN)
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end

  if vim.bo[bufnr].modified then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("write")
    end)
  end

  local cmd = vim.deepcopy(formatter[1])
  table.insert(cmd, filename)

  vim.system(cmd, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = result.stderr
        if not message or message == "" then
          message = result.stdout or "Formatter failed."
        end

        vim.notify(message, vim.log.levels.ERROR, {
          title = "Formatter",
        })
        return
      end

      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("edit!")
        end)
      end
    end)
  end)
end

vim.keymap.set("n", "<leader>cf", function()
  format_buffer()
end, {
  desc = "Format current buffer",
  silent = true,
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("CustomFormatter", { clear = true }),
--   callback = function(args)
--     format_buffer(args.buf)
--   end,
-- })
