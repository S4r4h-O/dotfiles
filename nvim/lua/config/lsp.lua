-- LSP basic settings
vim.o.autocomplete = true
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
  },

  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { ".git" },
  },

  pyrefly = {
    cmd = { "pyrefly", "lsp" },
    fyletypes = { "py", "pyi" },
    root_markers = { ".git" }
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

-- Autocmds
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method("textDocument/completion") then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    vim.lsp.buf.code_action({
      context = {
        only = { "source.organizeImports" },
      },
      apply = true,
    })
  end,
})
