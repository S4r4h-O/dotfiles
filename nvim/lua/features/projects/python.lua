local M = {}

---@param py_version string
local function _pyproject_extras(py_version)
  return {
    "",
    "[tool.pyrefly]",
    'project-includes = ["src"]',
    'search-path = ["src"]',
    ('python-version = "%s"'):format(py_version),
    "project-excludes = [",
    '\t"**/node_modules",',
    '\t"**/__pycache__",',
    '\t"**/.venv",',
    '\t"**/build",',
    '\t"**/dist",',
    "]",
    'untyped-def-behavior = "check-and-infer-return-type"',
    "",
    "[tool.ruff]",
    "line-length = 120",
    ('target-version = "py%s"'):format(py_version:gsub("%.", "")),
    "fix = true",
    'exclude = [".git", ".hg", ".pem", ".venv", "_build", "build", "dist"]',
    "",
    "[tool.ruff.lint]",
    "select = [",
    '\t"E",',
    '\t"W",    # pycodestyle',
    '\t"F",    # pyflakes',
    '\t"I",    # isort',
    '\t"UP",   # pyupgrade',
    '\t"B",    # bugbear',
    '\t"N",    # pep8-naming',
    '\t"C90",  # mccabe',
    '\t"PL",   # pylint',
    '\t"RUF",  # ruff-specific',
    '\t"ANN",  # flake8-annotations',
    '\t"A",    # flake8-builtins',
    '\t"C4",   # flake8-comprehensions',
    '\t"T20",  # flake8-print',
    '\t"SIM",  # flake8-simplify',
    '\t"ARG",  # flake8-unused-arguments',
    '\t"PTH",  # flake8-use-pathlib',
    '\t"PYI",  # flake8-pyi',
    '\t"ERA",  # eradicate (commented code)',
    '\t"S",    # flake8-bandit (security)',
    '\t"BLE",  # flake8-blind-except',
    '\t"FBT",  # flake8-boolean-trap',
    '\t"G",    # flake8-logging-format',
    '\t"PIE",  # flake8-pie',
    '\t"Q",    # flake8-quotes',
    '\t"RSE",  # flake8-raise',
    '\t"RET",  # flake8-return',
    '\t"SLF",  # flake8-self',
    '\t"SLOT", # flake8-slots',
    '\t"TID",  # flake8-tidy-imports',
    '\t"TC",   # flake8-type-checking',
    '\t"PERF", # perflint',
    '\t"FURB", # refurb',
    '\t"LOG",  # flake8-logging',
    '\t"TRY",  # tryceratops',
    '\t"YTT",  # flake8-2020',
    '\t"TD",   # flake8-todos',
    '\t"PT",   # flake8-pytest-style',
    '\t"INP",  # flake8-no-pep420',
    '\t"EM",   # flake8-errmsg',
    '\t"ISC",  # flake8-implicit-str-concat',
    '\t"FLY",  # flynt',
    '\t"PGH",  # pygrep-hooks',
    '\t"DOC",  # pydoclint',
    "",
    "]",
    'extend-select = ["I"]',
    "ignore = [",
    '\t"D100",    # Missing docstring in public module',
    '\t"D101",    # Missing docstring in public class',
    '\t"D106",    # Missing docstring in public nested class',
    '\t"D104",    # Missing docstring in public package',
    '\t"D203",    # 1 blank line required before class docstring',
    '\t"D213",    # Multi-line docstring summary should start at the second line',
    '\t"RUF012",  # Mutable class attributes should be annotated with `typing.ClassVar`',
    '\t"PLR0913", # too many arguments',
    '\t"PLR0912", # too many branches',
    '\t"PLR0915", # too many statements',
    '\t"PLR2004", # magic value used in comparison',
    '\t"S101",    # assert detected',
    '\t"TRY003",  # avoid specifying messages outside exception class',
    '\t"TD002",   # Missing author in TODO',
    '\t"TD003",   # Missing issue link in TODO',
    "]",
    "",
    "[tool.ruff.format]",
    'quote-style = "double"',
    'indent-style = "space"',
    "skip-magic-trailing-comma = false",
    'line-ending = "auto"',
    "docstring-code-format = true",
    "docstring-code-line-length = 72",
    "",
    "[tool.ruff.lint.pycodestyle]",
    "max-line-length = 88",
    "max-doc-length = 88",
    "",
    "[tool.ruff.lint.isort]",
    "combine-as-imports = true",
    "split-on-trailing-comma = true",
    'known-first-party = ["package_name"]',
    "force-sort-within-sections = true",
    "",
    "[tool.ruff.lint.pylint]",
    "max-args = 8",
    "max-branches = 15",
    "max-returns = 8",
    "max-statements = 60",
    "",
    "[tool.ruff.lint.flake8-quotes]",
    'inline-quotes = "double"',
    'multiline-quotes = "double"',
    "",
    "[tool.ruff.lint.flake8-bandit]",
    "check-typed-exception = true",
    "",
    "[tool.taskipy.tasks]",
    'test = "pytest --cov=src --cov-report=term-missing"',
    'lint = "ruff check . && ruff format --check ."',
    'format = "ruff check --fix . && ruff format ."',
    'post_test = "coverage html"',
    "",
    "[dependency-groups]",
    'dev = ["pytest", "pytest-cov", "pytest-mock"]',
    "",
  }
end

M.create_uv_project = function()
  if vim.fn.executable("uv") == 0 then
    vim.notify("uv is not installed", vim.log.levels.ERROR)
    return
  end

  local py_version = vim.fn.input("Enter the python version: ", "3.12")
  if not py_version or py_version == "" then
    return
  end

  local project_name = vim.fn.input("Enter the project name: ")
  if not project_name or project_name == "" then
    return
  end

  local choices = { "--package", "--no-package", "--app", "--library", "--script" }
  vim.ui.select(choices, { prompt = "Select a project type: " }, function(item, _)
    if not item then
      return
    end

    if item == "--script" then
      project_name = project_name .. ".py"
    end

    local cmd = { "uv", "init", "--python", py_version, item, project_name }

    vim
      .system(cmd, { text = true, timeout = 5000, stderr = true, stdout = true }, function(out)
        if out.code ~= 0 then
          vim.schedule(function()
            vim.notify("Failed to run " .. table.concat(cmd, " ") .. "\n" .. out.stderr, vim.log.levels.ERROR)
          end)
          return
        end

        vim.schedule(function()
          vim.notify(out.stdout, vim.log.levels.INFO)
        end)
      end)
      :wait(1000)

    vim.cmd("silent! cd " .. project_name)

    local pyproject_toml = vim.fs.joinpath(vim.fn.getcwd(), "pyproject.toml")

    if item ~= "--script" then
      local write = vim.fn.writefile(_pyproject_extras(py_version), pyproject_toml, "a")
      if write < 0 then
        vim.notify("Failed to append extras to pyproject.toml")
      end
    end
  end)
end

return M
