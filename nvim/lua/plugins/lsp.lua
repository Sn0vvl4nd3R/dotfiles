return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "single" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        lua_ls = {
          settings = { Lua = { diagnostics = { disable = { "missing-fields" } } } },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--fallback-style=llvm",
          },
          init_options = { fallbackFlags = { "-std=c++23" } },
        },
        zls = {
          settings = { zls = { enable_inlay_hints = true } },
        },
        tinymist = {
          settings = { formatterMode = "typstyle" },
        },
        pyright = {},
        bashls = {},
        rust_analyzer = {},
        jsonls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(k, f, desc)
            vim.keymap.set("n", k, f, { buffer = ev.buf, desc = desc, silent = true })
          end

          map("gd", vim.lsp.buf.definition, "LSP Definition")
          map("K", vim.lsp.buf.hover, "LSP Hover")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("gr", function() Snacks.picker.lsp_references() end, "References")

          if vim.lsp.inlay_hint then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "black" },
        lua = { "stylua" },
        typst = { "typstyle" },
        zig = { "zigfmt" },
        sh = { "shfmt" },
      },
    },
  },
}
