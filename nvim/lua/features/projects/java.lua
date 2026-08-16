local utils = require("features.utils")
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
-- [ ] Build java project
-- [ ] Run java proj
-- [ ] Run java tests
-- [ ] Debug?
-- [x] Create files (Class, Enums, Records, etc)
-- [ ] Create spring proj?
-- [x] Generate toString
-- [x] Generate toJson
-- [ ] clean repetition when calling M.request
-- [ ] should abstract floating windows

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

    vim.api.nvim_buf_set_name(buf, utils.gen_random_indentifier(item))

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

M.request = function(bufnr, method, params)
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    name = "jdtls",
  })

  local client = clients[1]

  if not client then
    vim.notify("No LSP client with name `jdtls` available", vim.log.levels.WARN)
    return
  end

  local win = vim.api.nvim_get_current_win()

  local context = vim.lsp.util.make_range_params(win, client.offset_encoding)

  params = vim.tbl_deep_extend("force", context, params or {})

  local done = false
  local result_err
  local result

  client:request(method, params, function(err, res)
    result_err = err
    result = res
    done = true
  end, bufnr)

  vim.wait(5000, function()
    return done
  end)

  return result_err, result
end

-- TODO: doesn't work very well lol
local function _get_class_pkg_from_dir(path)
  path = vim.fs.normalize(path)

  if vim.fn.isdirectory(path) == 0 then
    path = vim.fs.dirname(path)
  end

  local markers = {
    "/src/main/java",
    "/src/test/java",
  }

  for _, marker in ipairs(markers) do
    local pos = path:find(marker, 1, true)

    if pos then
      local pkg_path = path:sub(pos + #marker)

      if pkg_path == "" then
        return ""
      end

      return pkg_path:gsub("/", ".")
    end
  end

  return nil
end

-- M.get_class_package = function(buf)
--   buf = buf or vim.api.nvim_get_current_buf()
--
--   local win = vim.fn.bufwinid(buf)
--   if win == -1 then
--     win = vim.api.nvim_get_current_win()
--   end
--
--   local clients = vim.lsp.get_clients({
--     bufnr = buf,
--     name = "jdtls",
--   })
--
--   local curr_lsp = clients[1] or vim.lsp.get_clients({ bufnr = buf })[1]
--
--   if not curr_lsp then
--     vim.notify("No active LSP client", vim.log.levels.ERROR)
--     return
--   end
--
--   local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)
--
--   local err, result = M.request(0, "textDocument/documentSymbol", params)
--   if err then
--     vim.notify("Failed to execute `textDocument/documentSymbol`: " .. err.message, vim.log.levels.ERROR)
--     return
--   elseif not result then
--     return
--   end
--
--   for _, symbol in ipairs(result) do
--     if symbol.kind == vim.lsp.protocol.SymbolKind.Package then
--       return symbol.name
--     end
--   end
-- end

M.get_class_package = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for _, line in ipairs(lines) do
    local pkg = line:match("^%s*package%s+([%w%._]+)%s*;")
    if pkg then
      return pkg
    end
  end
end

-- Still needs a lot of work to function like Intellij's
M.create_java_file = function()
  local path = vim.fs.dirname(vim.fn.expand("%"))
  local pkg

  -- Handle class creation in neo-tree
  if vim.bo[vim.api.nvim_get_current_buf()].filetype == "neo-tree" then
    local manager = require("neo-tree.sources.manager")

    local state = manager.get_state("filesystem")
    if not state then
      return
    end

    local tree = state.tree
    local node = tree:get_node()
    path = node:get_id()

    pkg = _get_class_pkg_from_dir(path)
    if not pkg then
      vim.notify("Could not determine Java package from path", vim.log.levels.ERROR)
      return
    end
  else
    pkg = M.get_class_package()

    if not pkg then
      vim.notify("Could not find Java package", vim.log.levels.ERROR)
      return
    end
  end

  local classes = { "Class", "Enum", "Interface", "Record", "Annotation", "Exception" }
  vim.ui.select(classes, { prompt = "New Java Class: " }, function(item, _)
    if item == "" or item == nil then
      return
    end
    local classname = vim.fn.input("Enter class name: ")
    if classname == "" then
      return
    end

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

    local prefix = (item == "Exception") and "class" or item
    local suffix = (item == "Record") and "()" or (item == "Exception") and " extends RuntimeException" or ""
    local data = {
      ("package %s;"):format(pkg),
      "", -- newline
      ("public %s %s {}"):format(string.lower(prefix), classname .. suffix),
    }
    local fpath = vim.fs.joinpath(path, classname .. ".java")
    local res = vim.fn.writefile(data, fpath)
    if res < 0 then
      vim.notify("Failed to create file", vim.log.levels.ERROR)
      return
    end
    vim.cmd("silent! tabnew " .. fpath)
  end)
end

M.get_class_fields = function()
  local win = vim.api.nvim_get_current_win()
  local curr_lsp = vim.lsp.get_clients({ bufnr = 0 })[1]
  local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)

  local err, status = M.request(0, "java/checkConstructorsStatus", params)

  if err then
    vim.notify("Could not execute java/checkConstructorsStatus: " .. err.message, vim.log.levels.ERROR)
    return
  end

  if not status or not status.constructors or #status.constructors == 0 then
    return
  end

  local fieds = status.fields
  if fieds then
    return fieds
  end
  return {}
end

-- This allows the creation of identical constructors... :p
M.gen_java_constructor = function()
  local win = vim.api.nvim_get_current_win()
  local curr_lsp = vim.lsp.get_clients({ bufnr = 0 })[1]

  local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)

  vim.lsp.buf_request(0, "java/checkConstructorsStatus", params, function(err, result, context, config)
    if err then
      vim.notify("Failed to check constructor status: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if #result.constructors == 0 then
      return
    end

    local selected
    if #result.fields > 0 then
      selected = utils.select_many(result.fields, "Enter a range (e.g 1-3 or 2)", function(item)
        return string.format("%s %s", item.type, item.name)
      end)
    end

    if #selected > 0 then
      local parms = { context = params, constructors = result.constructors, fields = selected }
      -- This generates the constructor in the cursor position
      vim.lsp.buf_request(0, "java/generateConstructors", parms, function(err, result, context, config)
        if err then
          vim.notify("Failed to generate constructor: " .. err.message, vim.log.levels.ERROR)
        elseif result then
          vim.lsp.util.apply_workspace_edit(result, curr_lsp.offset_encoding)
        end
      end)
    end
  end)
end

local root_markers = { "pom.xml", "gradlew" }
local build_systems = { [root_markers[1]] = "mvn", [root_markers[2]] = "gradle" }

---@return "mvn"|"gradle"|nil
local function get_build_system()
  local root = vim.fs.root(0, root_markers)

  if root then
    for _, value in ipairs(root_markers) do
      local path = vim.fs.joinpath(root, value)
      if vim.uv.fs_stat(path) then
        return build_systems[value]
      end
    end
  else
    return
  end
end

--- Compile the Java workspace
---@param on_build_success fun(buf: integer): nil
M.compile = function(on_build_success)
  local source_buf = vim.api.nvim_get_current_buf()

  local build = get_build_system()
  if not build or build == "" then
    vim.notify("Build system not found", vim.log.levels.ERROR)
    return
  end

  local cmd = {
    ["mvn"] = { "mvn", "compile" },
    ["gradle"] = { "gradle", "clean", "build" },
  }

  cmd = cmd[build]

  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_buf_set_name(buf, utils.gen_random_indentifier(cmd[1]))

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

  --TODO: run class file after compiled
  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Failed to build project", vim.log.levels.ERROR)
        return
      end

      if on_build_success then
        on_build_success(source_buf)
      end
    end,
  })
end

--- Runs after M.compile. This method is used to run the class
--- file after compiled.
---@param buf integer
M.run_java_file = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local root = vim.fs.root(0, root_markers)

  local build_system = get_build_system()

  if not root or root == "" then
    vim.notify("Could not find root, probably not a Java project", vim.log.levels.ERROR)
    return
  end

  if vim.bo[buf].filetype ~= "java" then
    vim.notify("Not a Java file", vim.log.levels.ERROR)
    return
  end

  -- Example gradle:
  -- /tmp/gradle-project/app/build/classes/java/main/com/domain/App.class
  --
  -- Example mvn:
  -- /tmp/testing/target/classes/com/domain/App.class
  local targets = {
    ["mvn"] = "target/classes",
    ["gradle"] = "app/build/classes/java/main",
  }

  local pkg = M.get_class_package(buf)
  if not pkg or pkg == "" then
    vim.notify("Failed to find package", vim.log.levels.ERROR)
    return
  end

  local target_dir = targets[build_system]

  local fname = vim.api.nvim_buf_get_name(buf)
  fname = vim.fn.fnamemodify(fname, ":t:r")

  local cmd = { "java", "-cp", target_dir, pkg .. "." .. fname }

  vim.notify("Ready to run: " .. table.concat(cmd, " "))

  local run_buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_buf_set_name(run_buf, utils.gen_random_indentifier(cmd[1]))

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- FLoating window because it is cool
  vim.api.nvim_open_win(run_buf, true, {
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
        vim.notify("Failed to run file", vim.log.levels.ERROR)
        return
      end
    end,
  })
end

M.gen_to_string = function()
  local win = vim.api.nvim_get_current_win()
  local curr_lsp = vim.lsp.get_clients({ bufnr = 0 })[1]
  local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)

  local fields = M.get_class_fields()
  if not fields then
    return
  end

  local err, result = M.request(0, "java/checkToStringStatus", params)
  if err then
    vim.notify("Could not execute java/checkToStringStatus: " .. err.message, vim.log.levels.ERROR)
    return
  end
  if not result then
    return
  end
  if result.exists then
    local prompt = string.format("Method 'toString()' already exists in '%s'.", result.type)
    local choice = vim.fn.input(("%s\nReplace? (y/n): "):format(prompt))
    choice = string.lower(choice)
    if choice == "n" then
      return
    elseif choice ~= "y" then
      vim.notify("Invalid.", vim.log.levels.ERROR)
      return
    end
  end

  local choices = utils.select_many(fields, "Select the field(s)", function(item)
    return string.format("%s %s", item.type, item.name)
  end)

  if #choices > 0 then
    local err1, result1 = M.request(0, "java/generateToString", { context = params, fields = choices })
    if err1 then
      vim.notify("Could not execute java/generateToString: " .. err1.message, vim.log.levels.ERROR)
      return
    elseif result1 then
      vim.lsp.util.apply_workspace_edit(result1, curr_lsp.offset_encoding)
    end
  end
end

M.gen_hash_code_equals = function()
  local win = vim.api.nvim_get_current_win()
  local curr_lsp = vim.lsp.get_clients({ bufnr = 0 })[1]
  local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)

  local err, result = M.request(0, "java/checkHashCodeEqualsStatus", params)
  if err then
    vim.notify("Failed to execute `textDocument/documentSymbol`: " .. err.message, vim.log.levels.ERROR)
    return
  elseif not result then
    return
  elseif not result.fields or #result.fields == 0 then
    vim.notify(string.format("The operation is not applicable to the type %", result.type), vim.log.levels.WARN)
    return
  end

  local selected = utils.select_many(result.fields, "Select fields", function(item)
    return string.format("%s %s", item.type, item.name)
  end)

  if #selected > 0 then
    local err1, result1 = M.request(0, "java/generateHashCodeEquals", { context = params, fields = selected })
    if err1 then
      vim.notify("Failed to run `java/generateHashCodeEquals`: " .. err1.message, vim.log.levels.ERROR)
      return
    elseif result1 then
      vim.lsp.util.apply_workspace_edit(result1, curr_lsp.offset_encoding)
    end
  end
end

M.overried_methods = function()
  local win = vim.api.nvim_get_current_win()
  local curr_lsp = vim.lsp.get_clients({ bufnr = 0 })[1]
  local params = vim.lsp.util.make_range_params(win, curr_lsp.offset_encoding)

  local err, result = M.request(0, "java/listOverridableMethods", params)
  if err then
    vim.notify("Failed to execute `java/checkHashCodeEqualsStatus`: " .. err.message, vim.log.levels.ERROR)
    return
  elseif not result or not result.methods then
    vim.notify("No methods to override", vim.log.levels.INFO)
    return
  end

  local selected = utils.select_many(result.methods, "Select methods to override", function(item)
    return string.format("%s(%s) class: %s", item.name, table.concat(item.parameters, ", "), item.declaringClass)
  end)

  if not selected then
    return
  end

  if #selected > 0 then
    local err1, edit = M.request(0, "java/addOverridableMethods", { context = params, overridableMethods = selected })
    if err1 then
      vim.notify("Failed to override methods: " .. err1.message, vim.log.levels.ERROR)
      return
    elseif edit then
      vim.lsp.util.apply_workspace_edit(edit, curr_lsp.offset_encoding)
    end
  end
end

M.actions = {
  ["Create Java File"] = M.create_java_file,
  ["Generate constructor"] = M.gen_java_constructor,
  ["Generate toString"] = M.gen_to_string,
  ["Generate hashCode and equals"] = M.gen_hash_code_equals,
  ["Override methods"] = M.overried_methods,
  ["Build project"] = M.compile,
  ["Run file"] = function()
    M.compile(M.run_java_file)
  end,
}

M.java_actions = function()
  local items = {}
  for key, _ in pairs(M.actions) do
    table.insert(items, key)
  end
  table.sort(items)
  vim.ui.select(items, { prompt = "Select action: " }, function(item, idx)
    if not item or not idx then
      return
    end
    vim.schedule(function()
      M.actions[item]()
    end)
  end)
end

M.setup = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not M.is_java_project(bufnr) then
    return
  end
  vim.keymap.set("n", "<leader>ja", M.java_actions, { desc = "Java actions", buffer = bufnr })
end

return M
