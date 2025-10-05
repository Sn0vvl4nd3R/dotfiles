return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        mappings = {
          i = { ["<C-u>"] = false, ["<C-d>"] = false },
        },
        layout_strategy = "flex",
        layout_config = { horizontal = { preview_width = 0.6 }, vertical = { preview_height = 0.5 } },
        path_display = { "truncate" },
      },
      pickers = {
        buffers = { sort_lastused = true, ignore_current_buffer = true },
      },
    })
    pcall(telescope.load_extension, "fzf")

    local map = vim.keymap.set
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
    map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep (ripgrep)" })
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
    map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
  end,
}
