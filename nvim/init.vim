call plug#begin('~/.vim/plugged') 
Plug 'AckslD/nvim-neoclip.lua'
Plug 'mhartington/formatter.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'numToStr/Navigator.nvim'
Plug 'mfussenegger/nvim-lint'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-lualine/lualine.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'scrooloose/nerdcommenter'
Plug 'nvim-lua/popup.nvim'
Plug 'm4xshen/autoclose.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'willthbill/opener.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'folke/tokyonight.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'vimpostor/vim-tpipeline'
Plug 'goolord/alpha-nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

" Initialize plugin system
call plug#end()

let mapleader=";"

set cmdheight=0
set showtabline=2
set smarttab
set relativenumber
set shiftwidth=2
set cindent
set tabstop=2

function FormatBuffer()
  if &modified && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  endif
endfunction

autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag :call FormatBuffer()

lua require'nvim-tree'.setup {}
lua require("ibl").setup()
lua require('neoscroll').setup()
lua require('neoclip').setup()
inoremap jk <ESC>
nmap <C-n> :NvimTreeToggle<CR>
lua << END
require("autoclose").setup()
END


lua << END
require('lualine').setup()

END

lua require("Navigator").setup()
nnoremap <c-h> <cmd>NavigatorLeft<cr>
nnoremap <c-l> <cmd>NavigatorRight<cr>

vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope neoclip<cr>


noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" j/k will move virtual lines (lines that wrap)
nnoremap <leader>o :Telescope opener<cr>
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" always uses spaces instead of tab characters
set expandtab
colorscheme catppuccin

set termguicolors
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif




lua <<EOF
vim.o.termguicolors = true
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = { },
    disable = function(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
      end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
  },
}
vim.opt.scrolloff = 8
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local term = require("harpoon.tmux")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>q", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>l", function() ui.nav_next() end)
vim.keymap.set("n", "<leader>w", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>e", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>r", function() ui.nav_file(4) end)
vim.keymap.set("n", "<leader>t", function() term.gotoTerminal(1) end)
vim.keymap.set("n", "<leader>z", function() term.sendCommand(1, "npx live-server") end)
require('nvim-ts-autotag').setup()

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
-- keybindings are listed here:
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings
lsp_zero.default_keymaps({buffer = bufnr})
end)

-- technically these are "diagnostic signs"
-- neovim enables them by default.
-- here we are just changing them to fancy icons.
lsp_zero.set_sign_icons({
error = '✘',
warn = '▲',
hint = '⚑',
info = '»'
})

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
handlers = {
  lsp_zero.default_setup,
  lua_ls = function()
  local lua_opts = lsp_zero.nvim_lua_ls()
  require('lspconfig').lua_ls.setup(lua_opts)
  end,
}
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

-- this is the function that loads the extra snippets
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
-- if you don't know what is a "source" in nvim-cmp read this:
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/autocomplete.md#adding-a-source
sources = {
  {name = 'path'},
  {name = 'nvim_lsp'},
  {name = 'luasnip', keyword_length = 2},
  {name = 'buffer', keyword_length = 3},
},
-- default keybindings for nvim-cmp are here:
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/README.md#keybindings-1
mapping = cmp.mapping.preset.insert({
-- confirm completion item
['<Enter>'] = cmp.mapping.confirm({ select = true }),

-- trigger completion menu
['<C-Space>'] = cmp.mapping.complete(),

-- scroll up and down the documentation window
['<C-u>'] = cmp.mapping.scroll_docs(-4),
['<C-d>'] = cmp.mapping.scroll_docs(4),   

-- navigate between snippet placeholders
['<C-f>'] = cmp_action.luasnip_jump_forward(),
['<C-b>'] = cmp_action.luasnip_jump_backward(),
}),
-- note: if you are going to use lsp-kind (another plugin)
-- replace the line below with the function from lsp-kind
formatting = lsp_zero.cmp_format(),
})

lsp_zero.on_attach(function(client, bufnr)
local opts = {buffer = bufnr, remap = false}

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
vim.keymap.set("i", "<a-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('lint').linters_by_ft = {
  markdown = {'vale',},
}

require'lspconfig'.ast_grep.setup{}
function prettier()
  return {
    exe = 'prettier', -- change this to your prettier path
    args = {
      '--config-precedence',
      'prefer-file',
      '--print-width',
      vim.bo.textwidth,
      '--stdin-filepath',
      vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
  }
end
local black = { exe = 'black', args = {'-'}, stdin = true }
local gofmt = { exe = 'gofmt', args = {}, stdin = true }
local rustfmt = { exe = 'rustfmt', args = {'--emit=stdout'}, stdin = true }
local clang_format = { exe = 'clang-format', args = {}, stdin = true }
local stylua = { exe = 'stylua', args = {'--indent-width', '2', '-'}, stdin = true }

require('formatter').setup({
    filetype = {
        javascript = { prettier },
        html = { prettier },
        css = { prettier },
        typescript = { prettier },
        python = { black },
        go = { gofmt },
        rust = { rustfmt },
        c = { clang_format },
        lua = { stylua },
        -- Add more filetypes and corresponding formatters as needed
    }
})



EOF
au BufWritePost * lua require('lint').try_lint()

command! -nargs=0 -bar W w
command! -nargs=0 -bar Qa qa
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
