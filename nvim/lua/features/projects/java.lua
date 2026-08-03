local M = {}

M.is_java_project = function(bufnr)
  return vim.fs.root(bufnr or 0, {
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

-- TODOS:
-- Build java project
-- Run java proj
-- Run java tests
-- Debug?
-- Create files (Class, Enums, Records, etc)
-- Create spring proj?

M.create_java_project = function()
  local choices = { "Maven", "Gradle" }
  vim.ui.select(choices, {
    prompt = "Select a build system: ",
  }, function(item, _)
    if item == "" or item == nil then
      return
    end

    local group_id = vim.fn.input("Group ID: ")
    local artf_id = vim.fn.input("Project Name: ")

    if group_id == "" or artf_id == "" then
      return
    end

    local root = vim.fn.getcwd()

    local cmd
    if item == "Maven" then
      cmd = {
        "mvn",
        "archetype:generate",
        "-DgroupId=" .. group_id,
        "-DartifactId=" .. artf_id,
        "-DinteractiveMode=false",
      }
    elseif item == "Gradle" then
      -- Gradle creates the project files in the current dir,
      -- so we need to create a new dir and cd to it
      local projpath = vim.fs.joinpath(root, artf_id)
      local result = vim.fn.mkdir(projpath)
      if result ~= 1 then
        vim.notify("Failed to create project " .. artf_id .. " folder", vim.log.levels.ERROR)
        return
      end
      vim.cmd("silent! cd " .. projpath)
      cmd = {
        "gradle",
        "init",
        "--type",
        "java-application",
        "--dsl",
        "kotlin",
        "--project-name",
        artf_id,
        "--package",
        group_id,
      }
    end

    local buf = vim.api.nvim_create_buf(false, false)

    vim.api.nvim_buf_set_name(buf, item)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    -- FLoating window because it is cool
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      border = "rounded",
    })

    vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          vim.notify("Project creation failed", vim.log.levels.ERROR)
          return
        end

        if item == "Maven" then
          vim.cmd("silent! cd " .. vim.fn.fnameescape(artf_id))
        end

        vim.api.nvim_buf_delete(buf, {})
      end,
    })
  end)
end

-- Still needs a lot of work to function like Intellij's
M.create_java_file = function()
  -- Try to find the current package
  local pkg_line = vim.fn.search("^package\\s\\+\\zs[[:alnum:]_.]\\+", "nW")
  if pkg_line > 0 then
    local line = vim.api.nvim_buf_get_lines(0, pkg_line - 1, pkg_line, false)[1]
    local pkg = string.match(line, "^package%s+(%w+.*);$") -- Get current package name

    local classes = { "Class", "Enum", "Interface", "Record", "Annotation", "Exception" }
    vim.ui.select(classes, { prompt = "New Java Class: " }, function(item, _)
      if item == "" or item == nil then
        return
      end
      local classname = vim.fn.input("Enter class name: ")
      if classname == "" then
        return
      end

      local path = vim.fs.dirname(vim.fn.expand("%"))

      -- New packages are expressed with a dot (e.g "new.package"),
      -- and the class name should be the last part, for example:
      -- new.package.NewClass
      -- this will create current_package/new/package/NewClass.java
      if string.match(classname, "^%w+%.") then
        local i, j = string.find(classname, "%.%w+$") -- Get last part (the actual class name)
        local sub_paths = string.gsub(classname, "%.", "/")
        path = vim.fs.joinpath(path, sub_paths:sub(1, i))

        local res = vim.fn.mkdir(path, "-p")
        if res ~= 1 then
          vim.notify("Failed to create new packages", vim.log.levels.ERROR)
          return
        end

        -- Concat current package with new package
        pkg = ("%s.%s"):format(pkg, classname:sub(1, i - 1))
        -- Overwrite classname to last part only
        classname = classname:sub(i + 1, j)
      end

      local suffix = (item == "Record") and "()" or ""
      local data = {
        ("package %s;"):format(pkg),
        "", -- newline
        ("public %s %s {}"):format(string.lower(item), classname .. suffix),
      }
      local res = vim.fn.writefile(data, vim.fs.joinpath(path, classname .. ".java"))
      if res < 0 then
        vim.notify("Failed to create file", vim.log.levels.ERROR)
        return
      end
    end)
  end
end

M.setup = function(bufnr)
  if not M.is_java_project(bufnr) then
    return
  end
  vim.keymap.set("n", "<leader>pa", M.create_java_file, { desc = "Create Java File", buffer = bufnr })
end

return M
