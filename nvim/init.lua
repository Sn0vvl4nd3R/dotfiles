pcall(function() vim.loader.enable() end)

vim.g.loaded_node_provider = 0;
vim.g.loaded_ruby_provider = 0;
vim.g.loaded_perl_provider = 0;

vim.g.loaded_netrw = 1;
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    checker = { enabled = false },
    change_detection = { notify = false },
    ui = { border = "rounded" },
})

vim.cmd.colorscheme("github_dark_default")
