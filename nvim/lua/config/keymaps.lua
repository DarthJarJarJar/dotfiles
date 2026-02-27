local map = vim.keymap.set

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Move visual lines (wrapped lines)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- Navigator (wezterm pane integration)
map("n", "<C-h>", "<cmd>NavigatorLeft<cr>")
map("n", "<C-l>", "<cmd>NavigatorRight<cr>")

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>fc", "<cmd>Telescope neoclip<cr>")
map("n", "<leader>o", "<cmd>Telescope opener<cr>")

-- Harpoon
local mark = nil
local harpoon_ui = nil
local term = nil

-- These get set up after plugins load (see harpoon plugin spec)
-- but we define a helper to set them
function SetupHarpoonKeymaps()
  mark = require("harpoon.mark")
  harpoon_ui = require("harpoon.ui")
  term = require("harpoon.tmux")

  map("n", "<leader>a", mark.add_file)
  map("n", "<C-e>", harpoon_ui.toggle_quick_menu)
  map("n", "<leader>q", function() harpoon_ui.nav_file(1) end)
  map("n", "<leader>w", function() harpoon_ui.nav_file(2) end)
  map("n", "<leader>e", function() harpoon_ui.nav_file(3) end)
  map("n", "<leader>r", function() harpoon_ui.nav_file(4) end)
  map("n", "<leader>l", function() harpoon_ui.nav_next() end)
  map("n", "<leader>t", function() term.gotoTerminal(1) end)
  map("n", "<leader>z", function() term.sendCommand(1, "npx live-server") end)
end

-- Trouble (diagnostics panel)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")

-- BufferLine
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>")
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")

-- Typo commands
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
