local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "80"
opt.fillchars = { eob = " " }

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.updatetime = 300
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10

opt.clipboard:append("unnamedplus")

opt.splitbelow = true
opt.splitright = true
opt.iskeyword:append("-")

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
