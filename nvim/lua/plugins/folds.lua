return {
    { "kevinhwang91/promise-async" },
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        opts = {
            provider_selector = function(_, _, _)
                return { "treesitter", "indent" }
            end,
            open_fold_hl_timeout = 0,
        },
        config = function(_, opts)
            require("ufo").setup(opts)
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO: Open all folds" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO: Close all folds" })
        end,
    },
}
