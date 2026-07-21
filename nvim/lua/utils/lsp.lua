local acmds = require("config.autocmds")
-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
vim.opt.complete:append({ "o", "." })
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.o.pumheight = 10
vim.o.pumborder = "rounded"

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          documentationFormat = { "markdown", "plaintext" },
          labelDetailsSupport = true,
          deprecatedSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
        },
      },
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

local diagnostic_signs = {
  Error = "\u{f057} ",
  Warn = "\u{f071} ",
  Hint = "\u{ea61}",
  Info = "\u{f05a}",
}

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
  },
})

do
  local orig = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig(contents, syntax, opts, ...)
  end
end

local function lsp_on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end

  local bufnr = ev.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<leader>gd", function()
    require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end, opts)

  vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

  vim.keymap.set("n", "<leader>gS", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
  end, opts)

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

  vim.keymap.set("n", "<leader>D", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, { desc = "Line diagnostics" })

  vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.open_float({ scope = "cursor" })
  end, { desc = "Cursor diagnostics" })

  vim.keymap.set("n", "<leader>nd", function()
    vim.diagnostic.jump({ count = 1 })
  end, { desc = "Next diagnostic" })

  vim.keymap.set("n", "<leader>pd", function()
    vim.diagnostic.jump({ count = -1 })
  end, { desc = "Previous diagnostic" })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, {
    desc = "Hover documentation",
  })

  -- Already defined in fzf.lua, but I'll keep it here
  -- vim.keymap.set("n", "<leader>fr", function()
  --   require("fzf-lua").lsp_references()
  -- end, { desc = "LSP References" })
  -- vim.keymap.set("n", "<leader>ft", function()
  --   require("fzf-lua").lsp_typedefs()
  -- end, { desc = "LSP typedefs" })
  -- vim.keymap.set("n", "<leader>fs", function()
  --   require("fzf-lua").lsp_document_symbols()
  -- end, { desc = "LSP document symbols" })
  -- vim.keymap.set("n", "<leader>fw", function()
  --   require("fzf-lua").lsp_workspace_symbols()
  -- end, { desc = "LSP workspace symbols" })
  -- vim.keymap.set("n", "<leader>fi", function()
  --   require("fzf-lua").lsp_implementations()
  -- end, { desc = "LSP implementations" })

  if client:supports_method("textDocument/codeAction", bufnr) then
    vim.keymap.set("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
      vim.defer_fn(function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end, 50)
    end, { desc = "Organize imports" })
  end
end

-- Servers config and enabling
local servers = {

  bashls = {
    filetypes = { "sh", "bash", "zsh" },
    cmd = { "bash-language-server", "start" },
    settings = {
      bashIde = {
        globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
      },
    },
  },

  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      { ".luarc.json", ".luarc.jsonc" },
      ".git",
    },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },

  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { ".git" },
  },

  pyrefly = {
    cmd = { "pyrefly", "lsp" },
    filetypes = { "python", "pyi" },
    root_markers = { ".git" },
  },

  -- ty = {
  --   cmd = { "ty", "server" },
  --   fyletypes = { "py", "pyi" }
  -- }
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", { group = acmds.augroup, callback = lsp_on_attach })
