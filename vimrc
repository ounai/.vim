set ruler
set laststatus=2
set number
set title
set hlsearch
set nocompatible
set backspace=2
set showcmd
set mouse=a
set relativenumber
set showtabline=2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

filetype plugin indent on
filetype plugin on

syntax on

"execute pathogen#infect()

cnoremap %% <C-R>=expand('%:h').'/'<cr>
:nnoremap <CR> :noh<cr>

set omnifunc=syntaxcomplete#Complete

set wildignore+=node_modules

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

