return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "lua",
        "rust",
        "bash",
        "json",
        "yaml",
        "toml",
        "typst",
        "cmake",
        "make",
        "dockerfile",
        "zig",
        "markdown",
        "markdown_inline",
      },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
