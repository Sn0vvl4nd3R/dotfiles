return {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
        require("github-theme").setup({
            options = {
                transparent = true,
                terminal_colors = true,
                dim_inactive = true,
                styles = { comments = "italic", functions = "bold" },
            },
            groups = {
                github_dark_default = {
                    CursorLine = { bg = "#1c2030" },
                    Visual     = { bg = "#2a3350" },
                },
            },
        })
        vim.cmd.colorscheme("github_dark_default")
    end,
}
