return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "arstneioqwfpgjluy;hkxzcvbmd,./",
    modes = {
      search = { enabled = true },
      char = {
        jump_labels = true,
        multi_line = false,
        keys = { "f", "F", "t", "T" },
      },
    },
  },
  keys = {
    { "s", function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
    { "S", function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash TS nodes" },
    { "r", function() require("flash").remote() end,            mode = "o",               desc = "Flash remote" },
    { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" },      desc = "Flash TS search" },
  },
}
