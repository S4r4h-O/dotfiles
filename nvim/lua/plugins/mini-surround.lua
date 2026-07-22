return {
  "nvim-mini/mini.surround",
  opts = {
    custom_surroundings = {
      ["("] = {
        output = { left = "(", right = ")" },
      },
      ["["] = {
        output = { left = "[", right = "]" },
      },
      ["{"] = {
        output = { left = "{", right = "}" },
      },
    },
    mappings = {
      add = "S",
      delete = "ds",
      replace = "cs",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      update_n_lines = "",
    },
  },
}
