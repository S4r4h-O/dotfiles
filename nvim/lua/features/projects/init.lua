local M = {}

M.project_languages = {
  java = {
    markers = {
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts",
    },
  },

  python = {
    markers = {
      "pyproject.toml",
      "setup.py",
      "requirements.txt",
    },
  },

  cpp = {
    markers = {
      "CMakeLists.txt",
      "Makefile",
    },
  },
}

M._detect = function(bufnr)
  for name, project in pairs(M.project_languages) do
    local root = vim.fs.root(bufnr, project.markers)

    if root then
      return name, root
    end
  end
end

M.project_modules = {
  java = require("features.projects.java"),
  -- python = require("features.projects.python"),
}

function M.setup(bufnr)
  local name, root = M._detect(bufnr)

  if not name and not root then
    return
  end

  local project = M.project_modules[name]

  if project then
    project.setup(bufnr)
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  callback = function(args)
    M.setup(args.buf)
  end,
})

-- KEYMAPS
require("features.projects.keymaps")

return M
