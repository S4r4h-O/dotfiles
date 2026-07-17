--TODO: persistent global formatting toggle
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
  local ft = vim.bo[bufnr].filetype
  local formatter = formatters[ft]

  if not formatter then
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename == "" then
    return
  end

  local cmd = vim.deepcopy(formatter[1])
  table.insert(cmd, filename)

  vim.system(cmd, {}, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify(result.stderr, vim.log.levels.ERROR, { title = "Formatter" })
      end)
      return
    end

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("edit!")
        end)
      end
    end)
  end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("CustomFormatter", { clear = true }),
  callback = function(args)
    format_buffer(args.buf)
  end,
})
