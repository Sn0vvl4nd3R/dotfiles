return {
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
  init = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local function on_attach(_, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
      map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
      map("n", "gt", vim.lsp.buf.type_definition, "LSP: Type definition")
      map("n", "gr", vim.lsp.buf.references, "LSP: References")
      map("n", "gI", vim.lsp.buf.implementation, "LSP: Implementation")
      map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
      map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP: Signature help")
      map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
      map("n", "<leader>fd", vim.diagnostic.open_float, "LSP: Line diagnostics")
      map("n", "[d", vim.diagnostic.goto_prev, "LSP: Prev diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "LSP: Next diagnostic")
      map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "LSP: Format")
      if vim.lsp.inlay_hint then
        map("n", "<leader>uh", function()
          local ih = vim.lsp.inlay_hint
          local ok, enabled = pcall(function() return ih.is_enabled({ bufnr = bufnr }) end)
          if not ok then enabled = vim.b.inlay_hints_enabled == true end
          local function set(v)
            local s = pcall(ih.enable, v, { bufnr = bufnr })
            if not s then vim.b.inlay_hints_enabled = v end
          end
          set(not enabled)
        end, "LSP: Toggle inlay hints")
      end
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.g.rustaceanvim = {
      server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
          },
        },
      },
      tools = {
        executor = "toggleterm",
      },
    }
  end,
}
