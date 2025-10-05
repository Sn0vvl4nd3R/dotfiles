return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
        size = 14,
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = { border = "rounded" },
        shade_terminals = false,
    },
}
