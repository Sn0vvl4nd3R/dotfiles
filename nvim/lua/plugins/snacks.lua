-- [lua/plugins/snacks.lua]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      zen = { enabled = true },
      dashboard = { enabled = false },
      notifier = { enabled = false },
      input = { enabled = false },
      picker = {
        enabled = true,
        prompt = "> ",
        icons = {
          files = { enabled = false },
        },
        layout = {
          preset = "ivy",
        },
      },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fw", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
      { "<leader>xx", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Scratch Buffer" },
    },
  },
}
