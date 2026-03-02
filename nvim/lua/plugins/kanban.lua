return {
	{
		"arakkkkk/kanban.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("kanban").setup({
				markdown = {
					description_folder = "./.kanban/tasks/",
					list_head = "## ",
				},
			})

			local function project_root()
				local markers = { ".git", "typst.toml", "zettel.typ" }
				local start = vim.fn.expand("%:p:h")
				for _, m in ipairs(markers) do
					local found = vim.fs.find(m, { path = start, upward = true })[1]
					if found then
						return vim.fs.dirname(found)
					end
				end
				return vim.fn.getcwd()
			end

			local function kanban_path()
				return project_root() .. "/kanban.md"
			end

			vim.keymap.set("n", "<leader>kb", function()
				local p = kanban_path()
				if vim.fn.filereadable(p) == 1 then
					vim.cmd("KanbanOpen " .. p)
				else
					vim.cmd("KanbanCreate " .. p)
					vim.cmd("KanbanOpen " .. p)
				end
			end, { desc = "Kanban: open/create kanban.md in project" })

			vim.keymap.set("n", "<leader>kB", function()
				vim.cmd("KanbanOpen telescope")
			end, { desc = "Kanban: pick board via Telescope" })

			vim.keymap.set("n", "<leader>kt", function()
				local ok, tb = pcall(require, "telescope.builtin")
				if not ok then
					return
				end
				tb.live_grep({
					search_dirs = { project_root() },
					default_text = "#todo[",
				})
			end, { desc = "Typst: grep #todo[...]" })
		end,
	},
}
