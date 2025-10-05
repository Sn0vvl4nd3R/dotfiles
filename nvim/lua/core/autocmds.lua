local hl_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = hl_yank,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200, on_visual = true })
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
	local dir = vim.opt.undodir:get()
	local path = type(dir) == "table" and dir[1] or dir
	if type(path) == "string" and path ~= "" then
	    vim.fn.mkdir(path, "p")
	end
    end,
    desc = "Ensure undodir exists",
})
