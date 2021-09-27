" vim:set ts=2 sts=2 sw=2 expandtab:

" Begin loading plugins
call plug#begin('~/.vim/plugmcplugface')

" Command-T
Plug 'wincent/command-t', {
  \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
  \ }

" JS stuff
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

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

" Ignore node_modules in Command-T
set wildignore+=node_modules

" Fix slow 0 inserts (?)
:set timeout timeoutlen=1000 ttimeoutlen=100

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

