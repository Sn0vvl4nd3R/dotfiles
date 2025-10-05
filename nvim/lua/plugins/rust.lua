return {
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = { lsp = { enabled = true } },
    },
}
