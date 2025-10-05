vim.g.mapleader = " "

require("core.options")
require("core.keymaps")
require("core.autocmds")

local ok_notify, _ = pcall(require, "notify")
if not ok_notify then
    vim.notify = function(...)
        require("notify")(...)
    end
end
