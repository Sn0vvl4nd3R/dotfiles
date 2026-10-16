return {
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    keys = {
      { "<leader>na", "<cmd>Org agenda<CR>", desc = "Org Agenda" },
      { "<leader>nc", "<cmd>Org capture<CR>", desc = "Org Capture" },
    },
    opts = {
      org_agenda_files = { "~/sync/org/**/*" },
      org_default_notes_file = "~/sync/org/inbox.org",
      org_todo_keywords = { "TODO(t)", "DOING(i)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)" },
      org_hide_emphasis_markers = true,
      org_log_done = "time",
      org_log_into_drawer = "LOGBOOK",
      org_startup_indented = true,
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  DEADLINE: %t",
          target = "~/sync/org/inbox.org",
        },
        n = {
          description = "Note",
          template = "* %?\n  %U",
          target = "~/sync/org/notes.org",
        },
        j = {
          description = "Journal",
          template = "* %U\n%?",
          target = "~/sync/org/journal.org",
        },
      },
    },
  },
}
