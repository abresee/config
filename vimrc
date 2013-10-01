"this is vim, not vi!
set nocompatible 

""""""""""""""""""
" NeoBundle Stuff!
""""""""""""""""""

" required for NeoBundle
filetype off
if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim
    set rtp+=~/.local/lib/python3.3/site-packages/powerline/bindings/vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundle itself
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'majutsushi/tagbar'

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" Unite! united fuzzy ui plugin"
NeoBundle 'Shougo/unite.vim'

" code completion
NeoBundle 'Shougo/neocomplete'

" snippets
NeoBundle 'Shougo/neosnippet'
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

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

    imap <C-k>      <Plug>(neosnippet_expand_or_jump)
    smap <C-k>      <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>      <Plug>(neosnippet_expand_target)

NeoBundle 'Shougo/vimfiler.vim'

" git integration
NeoBundle 'tpope/vim-fugitive'

" Improved motion 
NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_leader_key = '<Leader><Leader>'

" Search results counter
NeoBundle 'IndexedSearch'

NeoBundle 'kchmck/vim-coffee-script'

" undoing above required for NeoBundle, tells vim to load 
" filetype specific plugin and indent files
filetype plugin indent on

"""""""""""""""""""""
" end NeoBundle stuff
"""""""""""""""""""""

" I like modelines! :)
set modeline

" tabs and spaces handling
set et ts=4 sts=4 sw=4
autocmd FileType html setlocal ts=2 sts=2 sw=2

" always show status bar
set ls=2

" incremental search
set incsearch

" line numbers
set nu

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

set clipboard="unnamedplus,exclude:cons\|linux"

set ve=block
set go="aceimtT"

syntax enable

" cursor position in status line
set ruler
" folding
set foldmethod=indent

" move around windows with ctrl+movement keys
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
 
" save file keybinds
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Return to last edit position when opening files 
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" function to auto-insert include guards in C/C++ headers
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction

autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '--include-vars',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }
endif

autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

let vala_comment_strings = 1
let vala_space_errors = 1
