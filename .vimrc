"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=/home/php/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/php/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Align'
NeoBundle 'vim-scripts/md5.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc', {
      \  'build' : {
      \    'windows' : 'tools\\update-dll-mingw',
      \    'cygwin'  : 'make -f make_cygwin.mak',
      \    'mac'     : 'make -f make_mac.mak',
      \    'linux'   : 'make',
      \    'unix'    : 'gmake',
      \   },
      \ }
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-endwise.git'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'violetyk/neocomplete-php.vim'
NeoBundle 'stephpy/vim-php-cs-fixer'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'PDV--phpDocumentor-for-Vim'

" neocomplete-php.vim
let g:neocomplete_php_locale = 'ja'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

"--------------------------------------
" Base setting
"--------------------------------------
syntax on

" colorscheme
set background=dark
colorscheme torte
let g:solarized_termcolors=256

" system
set nobackup
set noswapfile
set nowritebackup
set wrap
set shiftround
set hidden
set history=10000
set mouse=a
set ttymouse=xterm2
set showcmd
set textwidth=0
set cursorline
set clipboard=unnamed,autoselect
set nrformats=

" editor visual
set number

" tabs and indent
set expandtab
set smartindent
set shiftwidth=4
set tabstop=4

" fileencoding
set fenc=utf8
set fencs=utf8,sjis,euc-jp,iso-2022-jp,cp932

" brace match
set matchpairs& matchpairs+=<:>
set showmatch
set matchtime=3

" search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Can undo when stop vim
if has('persistent_undo')
  set undofile
  set undodir=./.vimundo,~/.vim/undo
endif

inoremap jj <Esc>
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" change target window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" change window size
nnoremap <S-Left> <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up> <C-w>-<CR>
nnoremap <S-Up> <C-w>+<CR>

"--------------
" PHP
"--------------
" set PHP dictionary
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict

" Syntax check when wrote files.
autocmd FileType php setlocal makeprg=php\ -l\ %
autocmd FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l

let php_folding = 0
let php_sql_query = 1
let php_baselib = 1
let php_htmllnStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
let php_parent_error_open = 1

"-----------------
" hilight
"-----------------
highlight Pmenu ctermbg = 4
highlight PmenuSel ctermbg = 1
highlight PMenuSbar ctermbg = 4

"-----------------
" noecomplete
"-----------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


"-----------------
" syntastic
"-----------------
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_highlighting = 1
let g:syntastic_php_php_args = '-l'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"-----------------
" php-cs-fixer
"-----------------
let g:php_cs_fixer_level = "all"
let g:php_cs_fixer_config = "default"
let g:php_cs_fixer_php_path = "php"

let g:php_cs_fixer_enable_default_mapping = 1
let g:php_cs_fixer_dry_run = 0
let g:php_cs_fixer_verbose = 0

"-----------------
" NERDTree
"-----------------
map <C-e> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows = 0
let g:NERDTreeMouseMode = 0
autocmd VimEnter * if !argc() | NERDTree ./ | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"let file_name = expand("%")
"if has('vim_starting') && file_name == ""
"    autocmd VimEnter * NERDTree ./
"endif

"-----------------
" quickrun
"-----------------
let g:quickrun_config={'*': {'split': ''}}
let g:quickrun_config._={ 'runner': 'vimproc',
      \ 'runner/vimproc/updatetime': 10,
      \ 'outputter/buffer/close_on_empty': 1,
      \ }

"-----------------
" lightline
"-----------------
set laststatus=2
set t_Co=256
let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }

"-----------------
" phpdocumentor
"-----------------
autocmd FileType php inoremap <C-p> <ESC>:call PhpDocSingle()<CR>i
autocmd FileType php nnoremap <C-p> :call PhpDocSingle()<CR>
autocmd FileType php vnoremap <C-p> :call PhpDocRange()<CR>

NeoBundleCheck
"=======================================
" vim:ft=vim:fenc=utf-8:ff=unix:fdm=marker:ts=2:sw=2:tw=80:et:
"=======================================
