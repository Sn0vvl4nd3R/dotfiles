return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "b0o/schemastore.nvim",
        "folke/neodev.nvim",
    },
    config = function()
        require("neodev").setup({})

        require("mason").setup({
            ui = { border = "rounded" },
            PATH = "prepend",
        })

        local lsp_servers = {
            "lua_ls",
            "pyright",
            "ruff",
            "rust_analyzer",
            "clangd",
            "ts_ls",
            "html",
            "cssls",
            "jsonls",
            "bashls",
            "yamlls",
        }

        require("mason-lspconfig").setup({
            ensure_installed = lsp_servers,
            automatic_installation = true,
        })

        require("mason-tool-installer").setup({
            ensure_installed = lsp_servers,
            run_on_start = true,
            auto_update = false,
            start_delay = 0,
            debounce_hours = 24,
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local function ih_is_enabled(bufnr)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            local ih = vim.lsp.inlay_hint
            if not ih then return false end
            local ok, enabled = pcall(function() return ih.is_enabled({ bufnr = bufnr }) end)
            if ok then return enabled end
            ok, enabled = pcall(ih.is_enabled, bufnr)
            if ok then return enabled end
            return vim.b.inlay_hints_enabled == true
        end

        local function ih_enable(bufnr, value)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            local ih = vim.lsp.inlay_hint
            if not ih then return end
            local ok = pcall(ih.enable, value, { bufnr = bufnr })
            if ok then return end
            ok = pcall(ih.enable, bufnr, value)
            if ok then return end
            if type(ih) == "function" then
                vim.b.inlay_hints_enabled = value
                pcall(ih, bufnr, value)
            end
        end

        local function toggle_inlay_hints(bufnr)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            ih_enable(bufnr, not ih_is_enabled(bufnr))
        end

        local on_attach = function(_, bufnr)
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
            map("n", "<leader>uh", function() toggle_inlay_hints(bufnr) end, "LSP: Toggle inlay hints")
        end

        local lspconfig = require("lspconfig")

        local servers = {
            pyright = {},
            ruff = {},
            ts_ls = {},
            html = {},
            cssls = {},
            bashls = {},
            clangd = {
                capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
            },

            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        check = { command = "clippy" },
                    },
                },
            },

            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },

            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas(),
                        keyOrdering = false,
                    },
                },
            },

            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            },
        }

        for name, conf in pairs(servers) do
            if name ~= "clangd" then
                conf.capabilities = capabilities
            end
            conf.on_attach = on_attach
            lspconfig[name].setup(conf)
        end

        local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.diagnostic.config({
            virtual_text = { spacing = 2, prefix = "●" },
            severity_sort = true,
            float = { border = "rounded" },
        })

        local lsp_handlers = vim.lsp.handlers
        if lsp_handlers and vim.lsp.with then
            lsp_handlers["textDocument/hover"] =
                vim.lsp.with(lsp_handlers.hover, { border = "rounded" })
            lsp_handlers["textDocument/signatureHelp"] =
                vim.lsp.with(lsp_handlers.signature_help, { border = "rounded" })
        end

        if vim.lsp.inlay_hint then
            vim.api.nvim_create_user_command("LspToggleInlayHints", function()
                toggle_inlay_hints()
            end, {})
        end
    end,
}
