" Core Behavior
set nocompatible              " Explicitly use Vim defaults over Vi
set hidden                    " Allow switching buffers without saving
set encoding=utf-8
set autoread                  " Reload files changed outside Vim (logs)
set mouse=a                   " Enable mouse for scrolling/resizing

" Visuals & UI
syntax on                     " Enable syntax highlighting
set number                    " Show line numbers
set relativenumber            " Fast jumping with {count}j/k
set cursorline                " Highlight current line
set termguicolors             " Better colors for modern terminals (Ghostty)
colorscheme catppuccin_mocha
set background=dark           " Optimized for dark themes

" Search
set ignorecase                " Case insensitive search...
set smartcase                 " ...until an uppercase letter is typed
set incsearch                 " Highlight matches as you type
set hlsearch                  " Keep matches highlighted

" Formatting (SRE Standard: YAML/Kubernetes)
set expandtab                 " Use spaces instead of tabs
set shiftwidth=2              " 2 spaces for YAML
set softtabstop=2
set tabstop=2
set ai                        " Auto indent
set si                        " Smart indent

" SRE Life Savers
set undofile                  " Persistent undo (saves after closing file)
set undodir=~/.vim/undo       " Keep undo files in one place
set noswapfile                " Disable swap files (prevents .swp clutter)

" Keybindings
let mapleader = "\<Space>"

" " Fast Save/Quit
" nnoremap <leader>w :w<cr>
" nnoremap <leader>q :q<cr>

" Clear Search Highlights
nnoremap <leader><esc> :noh<cr>

" " Buffer Navigation (Switching between different Log/Config files)
" nnoremap <leader>n :bn<cr>
" nnoremap <leader>p :bp<cr>

" " Integration
" " Use system clipboard for yank/paste (Works with your OSC 52 setup)
" set clipboard=unnamedplus