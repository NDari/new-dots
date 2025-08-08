--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- set the current $MYVIMRC if not set. This happens when an init file
-- is used with 'nvim -u initfile' to load a different profile
local filename = function()
  return debug.getinfo(2, "S").source:sub(2) -- Get source string, remove "@"
end
vim.env.MYVIMRC = filename()

if vim.g.vscode then
  vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
  vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
end

vim.cmd.colorscheme("slate") -- colo for when not using plugins. changes in the plugin folder

-- base setting
require("base")

-- plugin manager and plugins
local add_plugins = true
if add_plugins then
  require("plugins")
end
