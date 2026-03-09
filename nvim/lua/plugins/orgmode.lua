return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/sync/org/**/*",
				org_default_notes_file = "~/sync/org/inbox.org",
				org_todo_keywords = {
					"TODO(t)",
					"DOING(i)",
					"WAITING(w)",
					"|",
					"DONE(d)",
					"CANCELLED(c)",
				},

				org_hide_emphasis_markers = true,
			})
		end,
	},
}
