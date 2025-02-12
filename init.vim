" ~/.config/nvim/init.vim

" Install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()
" Theme and Visual
Plug 'folke/tokyonight.nvim'                " Modern theme
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'                 " Rainbow parentheses
Plug 'lukas-reineke/indent-blankline.nvim', { 'tag': 'v3.*' }  " Updated to v3
Plug 'norcalli/nvim-colorizer.lua'          " Color highlighter

" LSP and Completion
Plug 'neovim/nvim-lspconfig'                " LSP config
Plug 'williamboman/mason.nvim'              " LSP installer
Plug 'williamboman/mason-lspconfig.nvim'    " Mason LSP bridge
Plug 'hrsh7th/nvim-cmp'                     " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'                 " LSP completion
Plug 'hrsh7th/cmp-buffer'                   " Buffer completion
Plug 'hrsh7th/cmp-path'                     " Path completion
Plug 'hrsh7th/cmp-cmdline'                  " Command completion
Plug 'L3MON4D3/LuaSnip'                    " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'            " Snippet completion
Plug 'rafamadriz/friendly-snippets'         " Snippet collection

" File Management
Plug 'nvim-tree/nvim-tree.lua'             " File explorer
Plug 'nvim-tree/nvim-web-devicons'         " File icons
Plug 'nvim-telescope/telescope.nvim'        " Fuzzy finder
Plug 'nvim-lua/plenary.nvim'               " Telescope dependency

" Git Integration
Plug 'lewis6991/gitsigns.nvim'             " Git signs
Plug 'tpope/vim-fugitive'                  " Git commands

" Status Line and Bufferline
Plug 'nvim-lualine/lualine.nvim'           " Status line
Plug 'akinsho/bufferline.nvim'             " Buffer line

" Julia Support
Plug 'JuliaEditorSupport/julia-vim'        " Julia syntax

" Terminal and REPL
Plug 'akinsho/toggleterm.nvim', {'tag': '*'}

" Extra Tools
Plug 'windwp/nvim-autopairs'               " Auto pairs
Plug 'numToStr/Comment.nvim'               " Easy comments
Plug 'folke/which-key.nvim'                " Key binding helper
Plug 'stevearc/dressing.nvim'              " Better UI elements
Plug 'rcarriga/nvim-notify'                " Notification manager
Plug 'folke/todo-comments.nvim'            " TODO comments
call plug#end()

" Basic Settings
set number                  " Line numbers
set relativenumber         " Relative line numbers
set autoindent            " Auto indent
set expandtab             " Use spaces instead of tabs
set tabstop=4             " Tab width
set shiftwidth=4          " Indent width
set clipboard=unnamed     " System clipboard
set encoding=utf-8        " UTF-8 encoding
set termguicolors        " True color support
set cursorline           " Highlight current line
set signcolumn=yes       " Always show sign column
set mouse=a              " Enable mouse support
set updatetime=300       " Faster completion
set timeoutlen=400       " Faster key sequence completion
set conceallevel=0       " Show `` in markdown files
set splitright           " Vertical splits go right
set splitbelow           " Horizontal splits go below

" Theme Settings
colorscheme tokyonight-night
highlight Normal guibg=NONE ctermbg=NONE

" Key Mappings
let mapleader = " "       " Space as leader key

" Window Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer Navigation
nnoremap <TAB> :BufferLineCycleNext<CR>
nnoremap <S-TAB> :BufferLineCyclePrev<CR>

" Disable arrow keys and Enter in completion menu
inoremap <expr> <Up> pumvisible() ? "\<C-y>\<Up>" : "\<Up>"
inoremap <expr> <Down> pumvisible() ? "\<C-y>\<Down>" : "\<Down>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" File Explorer
nnoremap <C-n> :NvimTreeToggle<CR>

" Find Files
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" Git
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>

" Cell Navigation
nnoremap [c :call search('^#%%', 'bW')<CR>
nnoremap ]c :call search('^#%%', 'W')<CR>

" Load Lua Config
lua require('init')
