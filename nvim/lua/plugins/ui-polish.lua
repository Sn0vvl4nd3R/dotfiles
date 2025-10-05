return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
        lsp = { progress = { enabled = false } },
        presets = {
            command_palette = false,
            bottom_search   = true,
            lsp_doc_border  = true,
        },
        routes = {
            { filter = { event = "cmdline" }, view = "cmdline" },
        },
        views = {
            cmdline = {
                position = { row = "100%", col = 0 },
                size = { width = "100%", height = "auto" },
                border = { style = "none" },
                win_options = { winblend = 0 },
            },
        },
    },
}
