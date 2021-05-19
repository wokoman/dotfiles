call plug#begin("~/.config/nvim/plugged")
Plug 'vim-syntastic/syntastic'
Plug 'fratajczak/one-monokai-vim'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
call plug#end()

set guifont=IBM\ Plex\ Mono:h15
set relativenumber
set noshowmode
syntax enable
syntax on

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
