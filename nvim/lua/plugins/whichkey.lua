return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 400,
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>n", group = "Notes / Org" },
        { "<leader>o", group = "Open" },
        { "<leader>t", group = "Terminal" },
        { "<leader>w", group = "Windows" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>z", group = "Zen" },
      },
    },
  },
}
