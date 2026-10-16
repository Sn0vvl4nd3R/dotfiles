local map = vim.keymap.set

local function opts(desc)
  return { desc = desc, silent = true }
end

map("n", "n", "nzzzv", opts("Next search result"))
map("n", "N", "Nzzzv", opts("Previous search result"))
map("n", "<C-d>", "<C-d>zz", opts("Half-page down"))
map("n", "<C-u>", "<C-u>zz", opts("Half-page up"))

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

map({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>", opts("Save file"))

map("n", "<leader>wv", "<C-w>v", opts("Split vertically"))
map("n", "<leader>wh", "<C-w>s", opts("Split horizontally"))
map("n", "<leader>we", "<C-w>=", opts("Equalize windows"))
map("n", "<leader>wx", "<cmd>close<CR>", opts("Close window"))

map("n", "<C-h>", "<C-w>h", opts("Move to left window"))
map("n", "<C-j>", "<C-w>j", opts("Move to lower window"))
map("n", "<C-k>", "<C-w>k", opts("Move to upper window"))
map("n", "<C-l>", "<C-w>l", opts("Move to right window"))

map("n", "<C-Up>", "<cmd>resize +2<CR>", opts("Increase height"))
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts("Decrease height"))
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts("Decrease width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts("Increase width"))

map("n", "<A-j>", "<cmd>m .+1<CR>==", opts("Move line down"))
map("n", "<A-k>", "<cmd>m .-2<CR>==", opts("Move line up"))
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts("Move selection down"))
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts("Move selection up"))

map("v", "<", "<gv", opts("Indent left"))
map("v", ">", ">gv", opts("Indent right"))

map("n", "<leader>tt", "<cmd>terminal<CR>", opts("Open terminal"))
map("n", "<leader>ts", "<cmd>botright 15split | terminal<CR>", opts("Open terminal split"))
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts("Exit terminal mode"))

for i, mark in ipairs({ "A", "B", "C", "D" }) do
  map("n", "<leader>m" .. i, "m" .. mark, opts("Pin file to slot " .. i))
  map("n", "<leader>" .. i, "'" .. mark .. "zz", opts("Jump to slot " .. i))
end
map("n", "<leader>hl", "<cmd>marks ABCD<CR>", opts("List pinned files"))
