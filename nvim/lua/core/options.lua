local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1"
opt.cursorline = true
opt.termguicolors = true
opt.colorcolumn = "80"
opt.showmode = false
opt.fillchars = { eob = " ", vert = "│", fold = " " }
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.o.winborder = "single"

opt.shortmess:append("IWsC")
opt.cmdheight = 1
opt.laststatus = 3

opt.statusline = " %f %m%r%=%y  %l:%c  %p%% "

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 200
opt.timeoutlen = 250
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
