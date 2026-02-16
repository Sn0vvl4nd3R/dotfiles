-- ./after/ftplugin/typst.lua

local map = vim.keymap.set

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Find project root by searching for specific files upward
local function get_project_root()
	-- Try to find project markers (zettel.typ, typst.toml, .git)
	local markers = { "zettel.typ", "typst.toml", ".git" }

	for _, marker in ipairs(markers) do
		local found = vim.fs.find(marker, {
			path = vim.fn.expand("%:p:h"),
			upward = true,
		})[1]

		if found then
			return vim.fs.dirname(found)
		end
	end

	-- Fallback to current working directory
	return vim.fn.getcwd()
end

-- Check if current file is part of a zettelkasten project
local function is_zettelkasten_project()
	local found = vim.fs.find("zettel.typ", {
		path = vim.fn.expand("%:p:h"),
		upward = true,
	})[1]
	return found ~= nil
end

-- ============================================================================
-- Template System
-- ============================================================================

-- Base templates available for all typst files
local base_templates = {
	["Article"] = {
		'#set page(paper: "a4")',
		'#set text(font: "Linux Libertine", size: 11pt)',
		"#set par(justify: true)",
		"",
		"= Title",
		"",
		"Content here.",
	},
	["Report"] = {
		'#set page(paper: "a4", numbering: "1")',
		'#set text(font: "Linux Libertine", size: 12pt)',
		'#set heading(numbering: "1.1")',
		"",
		"= Introduction",
		"",
		"= Main Section",
		"",
		"= Conclusion",
	},
	["Minimal"] = {
		"= Title",
		"",
		"Start writing...",
	},
}

-- Zettelkasten-specific templates (only available in zettel projects)
local zettel_templates = {
	["Zettel Note"] = {
		'#import "../zettel.typ": *',
		'#show: doc => zettel(title: "New Note", tags: ("inbox",), doc)',
		"",
		"= Header",
		"#todo[Task description]",
	},
	["Zettel Daily"] = {
		'#import "../zettel.typ": *',
		'#show: doc => zettel(title: "Daily: ' .. os.date("%Y-%m-%d") .. '", tags: ("daily",), doc)',
		"",
		"= Time Slots",
		'#task(false, "09:00")[Morning task]',
		"",
		"= Notes",
		"#todo[Task for today]",
	},
}

-- Get available templates based on project type
local function get_available_templates()
	local templates = vim.tbl_extend("force", {}, base_templates)

	if is_zettelkasten_project() then
		templates = vim.tbl_extend("force", templates, zettel_templates)
	end

	return templates
end

-- ============================================================================
-- Auto-save System (with debounce to prevent performance issues)
-- ============================================================================

local save_timer = nil

local function setup_autosave()
	-- Clear any existing autosave autocmds for this buffer to prevent duplicates
	vim.api.nvim_clear_autocmds({
		buffer = 0,
		group = vim.api.nvim_create_augroup("TypstAutoSave", { clear = false }),
	})

	-- Create new autosave with debounce
	vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
		buffer = 0,
		group = vim.api.nvim_create_augroup("TypstAutoSave", { clear = false }),
		callback = function()
			if save_timer then
				vim.fn.timer_stop(save_timer)
			end

			save_timer = vim.fn.timer_start(500, function()
				if vim.bo.modified then
					vim.cmd("silent! write")
				end
			end)
		end,
	})
end

-- ============================================================================
-- Preview System
-- ============================================================================

-- Start typst watch process and open PDF viewer
local function preview_pdf()
	local buf = vim.api.nvim_get_current_buf()
	local pdf_path = vim.fn.expand("%:r") .. ".pdf"
	local root = get_project_root()

	-- Start typst watch if not already running
	if not vim.b[buf].typst_job then
		vim.b[buf].typst_job = vim.fn.jobstart({ "typst", "watch", vim.fn.expand("%:p"), "--root", root }, {
			detach = false,
			on_exit = function()
				vim.b[buf].typst_job = nil
			end,
		})

		-- Stop watch process when buffer is closed
		vim.api.nvim_create_autocmd("BufUnload", {
			buffer = buf,
			callback = function()
				if vim.b[buf].typst_job then
					vim.fn.jobstop(vim.b[buf].typst_job)
					vim.b[buf].typst_job = nil
				end
			end,
		})

		-- Setup autosave when preview starts
		setup_autosave()

		vim.notify("Typst watch started", vim.log.levels.INFO)
	end

	-- Open PDF viewer (check if PDF exists first)
	if vim.fn.filereadable(pdf_path) == 1 then
		vim.fn.jobstart({ "zathura", pdf_path }, { detach = true })
	else
		vim.notify("PDF not found. Waiting for compilation...", vim.log.levels.WARN)
		-- Wait a bit and try again
		vim.defer_fn(function()
			if vim.fn.filereadable(pdf_path) == 1 then
				vim.fn.jobstart({ "zathura", pdf_path }, { detach = true })
			end
		end, 1000)
	end
end

-- Stop preview (kill watch process)
local function stop_preview()
	local buf = vim.api.nvim_get_current_buf()
	if vim.b[buf].typst_job then
		vim.fn.jobstop(vim.b[buf].typst_job)
		vim.b[buf].typst_job = nil
		vim.notify("Typst watch stopped", vim.log.levels.INFO)
	else
		vim.notify("No active preview", vim.log.levels.WARN)
	end
end

-- Compile once without watch
local function compile_once()
	local root = get_project_root()
	local output = vim.fn.system({
		"typst",
		"compile",
		vim.fn.expand("%:p"),
		"--root",
		root,
	})

	if vim.v.shell_error == 0 then
		vim.notify("Compilation successful", vim.log.levels.INFO)
	else
		vim.notify("Compilation failed:\n" .. output, vim.log.levels.ERROR)
	end
end

-- ============================================================================
-- Zettelkasten Task/Todo Toggle
-- ============================================================================

local function toggle_task_checkbox()
	local line = vim.api.nvim_get_current_line()
	local new_line = line

	-- Toggle task checkbox: false <-> true
	if line:find("task%(false") then
		new_line = line:gsub("task%(false", "task(true")
	elseif line:find("task%(true") then
		new_line = line:gsub("task%(true", "task(false")
	-- Toggle todo/done markers
	elseif line:find("#todo") then
		new_line = line:gsub("#todo", "#done")
	elseif line:find("#done") then
		new_line = line:gsub("#done", "#todo")
	else
		vim.notify("No task/todo found on this line", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_set_current_line(new_line)
end

-- ============================================================================
-- Template Insertion
-- ============================================================================

local function insert_template()
	local templates = get_available_templates()
	local template_names = vim.tbl_keys(templates)

	-- Sort template names for consistent order
	table.sort(template_names)

	vim.ui.select(template_names, {
		prompt = "Select template:",
		format_item = function(item)
			-- Mark zettel templates differently
			if zettel_templates[item] then
				return item .. " [Zettel]"
			end
			return item
		end,
	}, function(choice)
		if choice then
			-- Insert template
			vim.api.nvim_buf_set_lines(0, 0, -1, false, templates[choice])

			-- Save file
			vim.cmd("write")

			vim.notify("Template '" .. choice .. "' inserted", vim.log.levels.INFO)
		end
	end)
end

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Template insertion
map("n", "<leader>zt", insert_template, {
	buffer = true,
	desc = "Insert Typst template",
})

-- Preview controls
map("n", "<leader>tp", preview_pdf, {
	buffer = true,
	desc = "Preview PDF (start watch)",
})

map("n", "<leader>ts", stop_preview, {
	buffer = true,
	desc = "Stop Typst preview",
})

map("n", "<leader>tc", compile_once, {
	buffer = true,
	desc = "Compile Typst once",
})

-- Task/todo toggle (especially useful for zettelkasten)
map("n", "<leader>x", toggle_task_checkbox, {
	buffer = true,
	desc = "Toggle task/todo checkbox",
})

-- Quick compilation and open
map("n", "<leader>to", function()
	compile_once()
	vim.defer_fn(function()
		local pdf_path = vim.fn.expand("%:r") .. ".pdf"
		if vim.fn.filereadable(pdf_path) == 1 then
			vim.fn.jobstart({ "zathura", pdf_path }, { detach = true })
		end
	end, 500)
end, {
	buffer = true,
	desc = "Compile and open PDF",
})

-- ============================================================================
-- Buffer Options
-- ============================================================================

-- Enable automatic .typ extension for gf (goto file)
vim.opt_local.suffixesadd:append(".typ")

-- Set text width for better formatting
vim.opt_local.textwidth = 80

-- Enable spell checking (useful for writing)
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- ============================================================================
-- Status Indicator
-- ============================================================================

-- Show whether this is a zettelkasten project
if is_zettelkasten_project() then
	vim.notify("Zettelkasten mode enabled", vim.log.levels.INFO)
end
