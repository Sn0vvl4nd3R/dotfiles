return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
				theme = {
					highlights = {
						LineNr = { bg = "NONE" },
						SignColumn = { bg = "NONE" },
						FoldColumn = { bg = "NONE" },
					},
				},
			})
			vim.cmd("colorscheme cyberdream")
		end,
	},
}
