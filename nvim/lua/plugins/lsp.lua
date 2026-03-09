return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.semanticTokens = vim.NIL

			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"clang-format",
					"black",
					"stylua",
					"google-java-format",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"pyright",
					"lua_ls",
					"tinymist",
					"bashls",
					"jsonls",
					"yamlls",
					"neocmake",
					"dockerls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									-- ВКЛЮЧАЕМ ПОДСКАЗКИ ДЛЯ LUA
									hint = { enable = true },
									diagnostics = { disable = { "missing-fields" } },
								},
							},
						})
					end,
					["clangd"] = function()
						require("lspconfig").clangd.setup({
							capabilities = capabilities,
							cmd = {
								"clangd",
								"--background-index",
								"--clang-tidy",
								"--header-insertion=iwyu",
								"--completion-style=detailed",
								"--function-arg-placeholders",
								"--fallback-style=llvm",
							},
						})
					end,
					["tinymist"] = function()
						require("lspconfig").tinymist.setup({
							capabilities = capabilities,
							offset_encoding = "utf-8",
							single_file_support = true,
							root_dir = function()
								return vim.loop.cwd()
							end,
							settings = {
								exportPdf = "never",
								formatterMode = "typstyle",
								semanticTokens = "disable",
							},
						})
					end,
				},
			})

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				performance = {
					debounce = 150,
					throttle = 60,
					fetching_timeout = 200,
					max_view_entries = 20,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })

						vim.keymap.set("n", "<leader>th", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
								{ bufnr = ev.buf }
							)
						end, { buffer = ev.buf, desc = "LSP: [T]oggle Inlay [H]ints" })
					end

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to Definition")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "Go to Declaration")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, "Format Buffer")

					local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
					if has_telescope then
						map("gr", telescope_builtin.lsp_references, "Goto References")
					else
						map("gr", vim.lsp.buf.references, "Goto References")
					end
				end,
			})
		end,
	},
}
