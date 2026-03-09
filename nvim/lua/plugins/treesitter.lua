return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"c",
				"cpp",
				"python",
				"java",
				"lua",
				"typst",
				"org",
				"bash",
				"json",
				"yaml",
				"toml",
				"cmake",
				"make",
				"dockerfile",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = { enable = false },
			textobjects = { enable = false },
		},
		config = function(_, opts)
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup(opts)
			end
		end,
	},
}
