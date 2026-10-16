set nocompatible
filetype plugin indent on
syntax enable

let mapleader = " "

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set nowrap

set number
set relativenumber
set signcolumn=yes
set cursorline
set colorcolumn=80
set scrolloff=8
set sidescrolloff=8
set splitbelow
set splitright
set noshowmode
set shortmess+=IWsC
set fillchars=vert:│,eob:\ ,fold:\ 

set background=light
if has('termguicolors')
  set termguicolors
endif

set backspace=indent,eol,start

set hidden
set updatetime=200
set timeout
set timeoutlen=300
set ttimeout
set ttimeoutlen=10
set noswapfile
set nobackup
set nowritebackup

if has('persistent_undo')
  let s:undodir = expand('~/.vim/undo')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p', 0700)
  endif
  let &undodir = s:undodir . '//'
  set undofile
endif

if has('clipboard')
  set clipboard^=unnamed,unnamedplus
endif

set ignorecase
set smartcase
set incsearch
set hlsearch

set path+=**
set wildmenu
if exists('&wildoptions')
  set wildoptions=pum,fuzzy
endif
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.bin,*.png,*.jpg,*.gif,*.pdf,*.pyc
set wildignore+=*/.git/*,*/node_modules/*,*/build/*,*/target/*,*/.cache/*

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

set completeopt=menuone,noinsert,noselect
set pumheight=10

inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <C-Space> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"

set laststatus=2

function! StatusMode() abort
  let l:modes = {
    \ 'n': 'NORMAL', 'i': 'INSERT', 'v': 'VISUAL', 'V': 'V-LINE',
    \ "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 'R': 'REPLACE', 't': 'TERMINAL'
    \ }
  return get(l:modes, mode(), mode())
endfunction

set statusline=
set statusline+=%#StatusLine#
set statusline+=\ [%{StatusMode()}]\ 
set statusline+=%f\ %m%r
set statusline+=%=
set statusline+=%y\ 
set statusline+=│\ %l:%c\ 
set statusline+=(%P)\ 

let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_keepdir = 0

nnoremap <silent> - :Explore<CR>

if !has('nvim') && !has('gui_running')
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
endif

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap <silent> <Esc> :nohlsearch<CR><Esc>
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>wv <C-w>v
nnoremap <leader>wh <C-w>s
nnoremap <leader>we <C-w>=
nnoremap <leader>wx :close<CR>

nnoremap <silent> <C-Up>    :resize +2<CR>
nnoremap <silent> <C-Down>  :resize -2<CR>
nnoremap <silent> <C-Left>  :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==
vnoremap <silent> <M-j> :m '>+1<CR>gv=gv
vnoremap <silent> <M-k> :m '<-2<CR>gv=gv

vnoremap < <gv
vnoremap > >gv

nnoremap <leader>ff :find *
nnoremap <leader>fb :ls<CR>:b<Space>
nnoremap <leader>fw :silent grep! 
nnoremap <silent> <leader>bd :bdelete<CR>

nnoremap <leader>m1 mA
nnoremap <leader>m2 mB
nnoremap <leader>m3 mC
nnoremap <leader>m4 mD
nnoremap <leader>1 'Azz
nnoremap <leader>2 'Bzz
nnoremap <leader>3 'Czz
nnoremap <leader>4 'Dzz
nnoremap <leader>hl :marks ABCD<CR>

if has('terminal')
  nnoremap <silent> <leader>tt :terminal ++curwin<CR>
  nnoremap <silent> <leader>ts :botright vertical 15split \| terminal ++curwin<CR>
  tnoremap <Esc><Esc> <C-\><C-n>
endif

augroup CoreAutocmds
  autocmd!

  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit\|rebase' |
    \   execute "normal! g`\"" |
    \ endif

  autocmd QuickFixCmdPost [^l]* cwindow
augroup END
