return {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: diagnostics" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",      desc = "Trouble: quickfix" },
    },
    opts = { use_diagnostic_signs = true },
}
