return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_fix" },
      rust = { "rustfmt" },
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },
      json = { "jq" },
      yaml = { "yamlfmt" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      sh = { "shfmt" },
      toml = { "taplo" },
      markdown = { "prettierd", "prettier" },
    },
    notify_on_error = true,
    format_on_save = function(bufnr)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > 300 * 1024 then
        return nil
      end
      return { lsp_fallback = true, timeout_ms = 1500 }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
