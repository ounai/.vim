" vim:set ts=2 sts=2 sw=2 expandtab:

" Begin loading plugins
call plug#begin('~/.vim/plug-plugins')

" Command-T
let g:CommandTPreferredImplementation='ruby'
Plug 'wincent/command-t', {
  \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
  \ }

" Language plugins
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'dense-analysis/ale'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'

" End loading plugins
call plug#end()

" Basic config
set nocompatible
set ruler
set title "set window title to current file name
set mouse=a "enable mouse in all modes
set number
set relativenumber
set hidden "allow unsaved background buffers and remember marks/undo for them
set history=10000 "remember more commands and search history
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase "make searches case-sensitive only if they contain upper-case characters
set cmdheight=1
set switchbuf=useopen
set showtabline=2 "always show tab bar at the top
set scrolloff=3 "prevent vim from clobbering the scrollback buffer
set backspace=indent,eol,start "allow backspacing over everything in insert mode
set showcmd "display incomplete commands
set autoread "if a file is changed outside of Vim, automatically reload it without asking
set diffopt=vertical "show diffs side-by-side
set signcolumn=no
set winwidth=79
set wildmenu "make tab completion for files/buffers act like bash
set signcolumn=number
set encoding=utf-8

" Indent with spaces
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" No backups
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" No command timeouts
set notimeout
set ttimeout

" Ignore stuff in Command-T
set wildignore+=node_modules "js
set wildignore+=dist "ts
set wildignore+=bin "ts
set wildignore+=target "rust

" Completion options: use a popup menu, show more info in menu (?)
:set completeopt=menu,preview

" Persistent undo history
if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile

" Enable file type detection
filetype plugin indent on

" Enable syntax highlighting
syntax on

" %% = current filename
cnoremap %% <C-R>=expand('%:h').'/'<cr>

map <leader>e :edit %%
map <leader>v :view %%

" <CR> = remove highlighting
:nnoremap <CR> :noh<cr>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Close all other splits
nnoremap <leader>o :only<cr>

" Swap between files
map <leader><leader> <c-^>

" Multipurpose tab key: indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
  let col = col('.') - 1

  if !col
    return "\<tab>"
  endif

  let char = getline('.')[col - 1]

  if char =~ '\k'
    " There's an identifier before the cursor, so complete the identifier.
    return "\<c-p>"
  else
    return "\<tab>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Open files where they were left off
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" <leader>n = rename current file
function! RenameCurrentFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))

  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameCurrentFile()<cr>

" Configure ALE
let g:ale_fixers = {
 \ 'javascript': ['eslint']
 \ }

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_set_highlights = 0
let g:ale_fix_on_save = 0

" Toggle sign column
function! ToggleSignColumn()
  if !exists("b:signcolumn_on") || b:signcolumn_on
    set signcolumn=no
    let b:signcolumn_on=0
  else
    set signcolumn=number
    let b:signcolumn_on=1
  endif
endfunction

nnoremap <leader>s :call ToggleSignColumn()<CR>

" Create new empty splits
map <leader>ws :new<cr>
map <leader>wv :vnew<cr>

" Execute files with <leader>x
map <leader>x :!clear && %:p<cr>

function SwapBool()
  let s:w = expand("<cword>")

  if s:w == "false"
    normal ciwtrue

    if expand("<cword>") != "true"
      normal u
    endif
  elseif s:w == "true"
    normal ciwfalse

    if expand("<cword>") != "false"
      normal u
    endif
  endif
endfunction

" Change boolean values with <leader>b
noremap <leader>b :call SwapBool()<CR>
