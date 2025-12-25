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
Plug 'preservim/nerdcommenter'
Plug 'skywind3000/vim-terminal-help'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
colorscheme tokyonight

" auto-save
let g:auto_save = 1 " enable AutoSave on Vim startup
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_events = ["InsertLeave", "TextChanged"]


set number
set noerrorbells
set nocompatible
syntax on
set mouse=a
set t_Co=256
filetype indent on
set autoindent
set tabstop=4
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


"NerdCommenter
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
nnoremap <silent> <leader>c} V}:call nerdcommenter#Comment('x', 'toggle')<CR>
nnoremap <silent> <leader>c{ V{:call nerdcommenter#Comment('x', 'toggle')<CR>


" set wrap
function! ToggleWrap()
    if &wrap == 1
        set nowrap
    else 
        set wrap
    endif
endfunction

nnoremap <A-w> :call ToggleWrap()<CR>
vnoremap y "+y



" coc.nvim
" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" 使用 <CR> 确认补全项
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

