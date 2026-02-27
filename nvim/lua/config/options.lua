local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.cindent = true

-- UI
opt.termguicolors = true
opt.scrolloff = 8
opt.cmdheight = 0
opt.showtabline = 2
opt.signcolumn = "yes"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Misc
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.updatetime = 250
