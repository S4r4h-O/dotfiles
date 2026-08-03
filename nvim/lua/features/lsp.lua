local map = vim.keymap.set
-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
local lsp_group = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

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
  local opmts = { noremap = true, silent = true, buffer = bufnr }

  map("n", "<leader>gS", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
  end, {
    desc = "Jump to definition and split buffer",
    silent = true,
    buffer = bufnr,
  })

  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  map("n", "<leader>ch", "<cmd>checkhealth vim.lsp<cr>", { desc = "Checkhealth LSP" })

  map("n", "<leader>D", function()
    vim.diagnostic.open_float({ scope = "line" })
  end, { desc = "Line diagnostics" })

  map("n", "<leader>d", function()
    vim.diagnostic.open_float({ scope = "cursor" })
  end, { desc = "Cursor diagnostics" })

  map("n", "K", vim.lsp.buf.hover, {
    desc = "Hover documentation",
  })

  -- Already defined in fzf.lua, but I'll keep it here
  -- map("n", "<leader>fr", function()
  --   require("fzf-lua").lsp_references()
  -- end, { desc = "LSP References" })
  -- map("n", "<leader>ft", function()
  --   require("fzf-lua").lsp_typedefs()
  -- end, { desc = "LSP typedefs" })
  -- map("n", "<leader>fs", function()
  --   require("fzf-lua").lsp_document_symbols()
  -- end, { desc = "LSP document symbols" })
  -- map("n", "<leader>fw", function()
  --   require("fzf-lua").lsp_workspace_symbols()
  -- end, { desc = "LSP workspace symbols" })
  -- map("n", "<leader>fi", function()
  --   require("fzf-lua").lsp_implementations()
  -- end, { desc = "LSP implementations" })

  if client:supports_method("textDocument/codeAction", bufnr) then
    map("n", "<leader>co", function()
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

  typescript = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript" },
    root_markers = { ".git", "node_modules", "packages.json" },
  },

  kotlin = {
    cmd = { "intellij-server", "--stdio" },
    filetypes = { "kotlin" },
    root_markers = { ".git", "pom.xml" },
  },

  rust = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json" },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = lsp_on_attach,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    map("n", "<C-[>", function()
      vim.diagnostic.jump({ count = 1 })
    end, { desc = "Next diagnostic", buffer = args.buf })

    map("n", "<C-]>", function()
      vim.diagnostic.jump({ count = -1 })
    end, { desc = "Previous diagnostic", buffer = args.buf })
  end,
})

-- Java config
-- jdtls should be located in ~/.local/share (e.g ~/.local/share/jdtls)
local function _java_root(bufnr)
  return vim.fs.root(bufnr, {
    "pom.xml",
    "build.gradle",
    "gradlew",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
    ".mvn",
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    local root     = _java_root(args.buf)
    local jdtls    = vim.env.HOME         .. "/.local/share/jdtls"
    local config   = jdtls                .. "/config_linux"
    local launcher = vim.fn.glob(jdtls    .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    local JAVA_ENV = vim.env.JAVA_HOME
    if JAVA_ENV == nil then
      vim.notify("JAVA_ENV was not found, fix it first", vim.log.levels.ERROR)
      return
    end

    local java = JAVA_ENV .. "/bin/java"

    local workspace

    if root then
      local name = vim.fn.fnamemodify(root, ":t")
      local id = vim.fn.sha256(root):sub(1, 8)

      workspace = vim.fn.stdpath("state") .. "/jdtls/" .. name .. "-" .. id
    else
      -- Better for scripts
      workspace = vim.fn.stdpath("state") .. "/jdtls-scratch"
    end

    local client = vim.lsp.start({
      name = "jdtls",
      cmd = {
        java,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-Xmx1G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens=java.base/java.util=ALL-UNNAMED",
        "--add-opens=java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher,
        "-configuration",
        config,
        "-data",
        workspace,
      },
      root_dir = root,
    })

    vim.notify(("jdtls started (id=%s)"):format(client), vim.log.levels.INFO)
  end,
})

-- vim.api.nvim_create_user_command("FormatToggle", function()
--   vim.g.autoformat = not vim.g.autoformat
--   vim.notify("Autoformat " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO)
-- end, {})
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
--   callback = function(args)
--     if not vim.g.autoformat or vim.b.autoformat == false then
--       return
--     end
--     vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 3000 })
--   end,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local opts = { buffer = args.buf }
--
--     I'm using fzf.lua for some of these
--     map("n", "gd", vim.lsp.buf.definition, opts)
--     map("n", "gr", vim.lsp.buf.references, opts)
--     map("n", "gD", vim.lsp.buf.declaration, opts)
--     map("n", "gi", vim.lsp.buf.implementation, opts)
--
--   end,
-- })
