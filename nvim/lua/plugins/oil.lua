return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = { "Oil" },
  keys = {
    { "-",         function() require("oil").open() end, desc = "Oil: parent directory" },
    { "<leader>e", function() require("oil").open() end, desc = "Oil: file explorer" },
  },
  opts = {
    default_file_explorer = true,
    view_options = { show_hidden = true },
    columns = { "icon" },
    float = { padding = 2, border = "rounded" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
