return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			vim.g.clang_format_style = "Google"

			local format_styles = {
				"LLVM",
				"Google",
				"Chromium",
				"Mozilla",
				"WebKit",
				"Microsoft",
				"GNU",
				"file",
			}

			conform.setup({
				formatters_by_ft = {
					c = { "clang_format" },
					cpp = { "clang_format" },
					python = { "black" },
					lua = { "stylua" },
					java = { "google-java-format" },
					typst = { "typstyle" },
				},

				formatters = {
					clang_format = {
						prepend_args = function()
							return { "--style=" .. vim.g.clang_format_style }
						end,
					},
				},

				format_on_save = function(bufnr)
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return
					end

					return {
						timeout_ms = 500,
						lsp_fallback = true,
					}
				end,
			})

			local function select_format_style()
				local current_idx = 1
				for i, style in ipairs(format_styles) do
					if style == vim.g.clang_format_style then
						current_idx = i
						break
					end
				end

				local options = {}
				for i, style in ipairs(format_styles) do
					if i == current_idx then
						table.insert(options, style .. " (current)")
					else
						table.insert(options, style)
					end
				end

				vim.ui.select(options, {
					prompt = "Select formatting style:",
					format_item = function(item)
						return "  " .. item
					end,
				}, function(choice, idx)
					if choice then
						local selected_style = format_styles[idx]
						vim.g.clang_format_style = selected_style

						vim.notify("Formatting style set to: " .. selected_style, vim.log.levels.INFO)

						local format_now = vim.fn.input("Format current buffer now? (y/n): ")
						if format_now:lower() == "y" then
							conform.format({
								bufnr = vim.api.nvim_get_current_buf(),
								timeout_ms = 1000,
							})
						end
					end
				end)
			end

			local function format_buffer()
				conform.format({
					bufnr = vim.api.nvim_get_current_buf(),
					timeout_ms = 1000,
					lsp_fallback = true,
				})
			end

			vim.keymap.set("n", "<leader>fm", format_buffer, {
				desc = "Format buffer with current style",
			})

			vim.keymap.set("n", "<leader>fs", select_format_style, {
				desc = "Select formatting style",
			})

			vim.keymap.set("n", "<leader>fi", function()
				vim.notify("Current formatting style: " .. vim.g.clang_format_style, vim.log.levels.INFO)
			end, {
				desc = "Show current formatting style",
			})
		end,
	},
}
