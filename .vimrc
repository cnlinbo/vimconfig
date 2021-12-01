set nocompatible

" Import plugins
if filereadable($HOME."/.vim/autoload/plug.vim")
  call plug#begin('~/.vim/plugged')
  Plug 'tomasr/molokai'
  Plug 'Raimondi/delimitMate'
  Plug 'lervag/vimtex'
  if v:version >= 801
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  endif
  call plug#end()
endif

" Basic configuration
set backspace=indent,eol,start
set hls
set t_Co=256
set number
set mouse+=a

" Turn off the beep
set noeb vb t_vb=

" Bind key to turn on/off paste mode
set pastetoggle=<f12>

" Use molokai color theme
if filereadable($HOME."/.vim/plugged/molokai/colors/molokai.vim")
  colorscheme molokai
endif

" Vimtex configuration
let g:vimtex_view_general_viewer = 'open -a texshop'
let g:vimtex_quickfix_open_on_warning = 0

" Color configuration for visual mode
highlight Visual cterm=none ctermbg=darkgrey ctermfg=cyan

" Basic indentation configuration
set et
set sta
set sw=2
set sts=2

" Indentation configuration for programming languages
autocmd FileType c,cpp setlocal et sta sw=2 sts=2 cino=g0
autocmd FileType sh,python setlocal et sta sw=4 sts=4

" Editing configuration for C/C++
autocmd FileType c,cpp imap {<CR> {}<ESC>i<CR><ESC>O

" Turn to the last open accurate postion when open files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Make line with cursor centered on the screen when open files
autocmd VimEnter * normal zz

" Clipboard configuration for desktop
set clipboard^=unnamed,unnamedplus

" Commenting code configuration
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
  autocmd FileType sh,ruby,python let b:comment_leader = '# '
  autocmd FileType conf,fstab let b:comment_leader = '# '
  autocmd FileType tex let b:comment_leader = '% '
  autocmd FileType mail let b:comment_leader = '> '
  autocmd FileType vim let b:comment_leader = '" '
augroup END
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader, '\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader, '\/')<CR>//e<CR>:nohlsearch<CR>
