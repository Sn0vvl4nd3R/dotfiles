return {
  {
    "stevearc/oil.nvim",
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    opts = {
      view_options = { show_hidden = true },
      default_file_explorer = true,
    },
  },

  {
    "mbbill/undotree",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
  },

  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
