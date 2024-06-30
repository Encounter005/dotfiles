call plug#begin()
Plug 'https://github.com/enml/nord-vim.git'
Plug 'https://github.com/itchyny/vim-cursorword.git'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/vim-slash'
Plug 'majutsushi/tagbar'
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim'
Plug '907th/vim-auto-save'
Plug 'skywind3000/vim-terminal-help'
" colorscheme
Plug 'sainnhe/sonokai'
Plug 'ray-x/aurora'
Plug 'ghifarit53/tokyonight-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()


set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
"let g:tokyonight_transparent_background = 1
colorscheme catppuccin_mocha

" auto-save
let g:auto_save = 1 " enable AutoSave on Vim startup
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

set clipboard=unnamedplus

set number
set noerrorbells
set nocompatible
syntax on
set mouse=a
set t_Co=256
filetype indent on
set autoindent
set tabstop=2
set shiftwidth=4
set expandtab
set softtabstop=2
set cursorline
set linebreak
set wrapmargin=2
set scrolloff=10
set laststatus=2
set ruler
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoread
set wildmenu
set wildmode=longest:list,full
let mapleader = " "  
map <leader>e :NERDTreeToggle<CR>
map <C-s> :w<CR>



let g:terminal_height = 14
map <C-\> <A-=>


let g:vim_markdown_math = 1

"激活tagbar扩展
let g:airline#extensions#tagbar#enabled = 1

"设置tagber对于markdown的支持
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Chapter',
        \ 'i:Section',
        \ 'k:Paragraph',
        \ 'j:Subparagraph'
    \ ]
\ }

let g:auto_save_events = ["InsertLeave", "TextChanged"]



