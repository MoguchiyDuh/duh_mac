vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

require("duh.options")
require("duh.lang").load()
require("duh.lazy")
require("duh.keymaps")
require("duh.autocmds")
