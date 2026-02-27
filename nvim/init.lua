-- Ayaan's Neovim Config
-- Leader key (must be set before lazy.nvim loads plugins)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugin manager (lazy.nvim)
require("config.lazy")
