""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vundle (https://github.com/gmarik/Vundle.vim#about)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'bling/vim-airline'
Plugin 'Shougo/neocomplete.vim'
Plugin 'eagletmt/neco-ghc'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'Shougo/vimproc.vim.git', { 'do': 'make' }
Plugin 'godlygeek/tabular.git'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" syntax highlighting
Plugin 'haskell.vim'
Plugin 'Cabal.vim'
Plugin 'pbrisbin/vim-syntax-shakespeare'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'plasticboy/vim-markdown'
Plugin 'digitaltoad/vim-jade'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nachumk/systemverilog.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'luochen1990/rainbow'
Plugin 'gisraptor/vim-lilypond-integrator'
Plugin 'tomlion/vim-solidity'

call vundle#end()
filetype plugin indent on  " required

" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install (update) bundles
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused bundles
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" remap <leader> to ,
let mapleader = ","
"
" brilliant remap of : to ; credit to @sagnew
nnoremap ; :

" disable line wrapping; I often do :set wrap when dealing with wide files.
set nowrap

" I like being able to scroll with the mouse, since it's so close-by
" on my laptop keyboard anyway; f4 disables it for ease of copying single
" lines, and f3 reenables it
set mouse=a 
nnoremap <F3> :set mouse=a<CR>
nnoremap <F4> :set mouse=<CR>

" Key bindings for adjusting the tab/shift width.
nnoremap <leader>w2 :setlocal tabstop=2<CR>:setlocal shiftwidth=2<CR>
nnoremap <leader>w4 :setlocal tabstop=4<CR>:setlocal shiftwidth=4<CR>
nnoremap <leader>w8 :setlocal tabstop=8<CR>:setlocal shiftwidth=8<CR>

" Save current file with root privileges
cmap w!! w !sudo tee >/dev/null %

" f2 to toggle paste mode; ie, when you want to paste stuff into vim, hit f2
" and autoindent and a couple of other things will be temporarily shut off so
" it gets pasted in correctly. 
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" color the normally paren-highlight 
highlight MatchParen ctermfg=darkblue

" this was to make searches readable in otherwise awful coloring
" hi Search cterm=NONE ctermfg=grey ctermbg=darkblue
" hi Visual cterm=NONE ctermfg=black ctermbg=darkyellow

" fix bug with hitting shift+o to add a new line before
" it normally waits like 5 seconds to do anything when you use shift+o, this makes it immediate
set timeout timeoutlen=1000 ttimeoutlen=100

" long syntax highlighting slows down vim
set synmaxcol=512

" map save and quit to Q
nnoremap <silent> Q ZZ

" <Ctrl-l> removes search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" keep visual selection when indenting/outdenting
vnoremap < <gv
vnoremap > >gv

" make tab completion in :e and the like more like bash
" set wildmode=longest:full,full
" set wildmenu

set completeopt=menuone,menu,longest

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

set cmdheight=1

" my sexy tool for rearranging vim windows; grab a window with ,u and paste it
" with ,h ,j ,k ,l which put it relative to the window you're in when you use them
" there's also ,<shift-u> to copy a window
let g:wingrab_last_buffer = -1
function! Wincp()
    let g:wingrab_last_buffer = bufnr("%")
endfunction

nnoremap ,u :call Wincp()<CR>:hide<CR><C-=><ESC><ESC>
nnoremap ,<S-U> :call Wincp()<CR><ESC><ESC>
nnoremap ,h :aboveleft vnew<CR>:execute "buffer! " . g:wingrab_last_buffer<CR><C-=><ESC><ESC>
nnoremap ,l :rightbelow vnew<CR>:execute "buffer! " . g:wingrab_last_buffer<CR><C-=><ESC><ESC>
nnoremap ,k :aboveleft new<CR>:execute "buffer! " . g:wingrab_last_buffer<CR><C-=><ESC><ESC>
nnoremap ,j :rightbelow new<CR>:execute "buffer! " . g:wingrab_last_buffer<CR><C-=><ESC><ESC>

" show the version of this file that is currently committed to git, if we're in a git repo; useless otherwise
nnoremap ,z :vnew \| setlocal syntax=<C-r>=&syntax<CR> \| r !git show HEAD:<C-r>=bufname("%")<CR><CR><ESC>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable<CR><ESC><ESC>

" ,pf runs pytest on the current file and shows its output in a new window
nnoremap ,pf :vnew \| r !py.test <C-r>=bufname("%")<CR><CR><ESC>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable<CR><ESC><ESC>
" ,pa runs pytest in the directory vim was opened from with no filtering as to what is run
nnoremap ,pa :vnew \| r !py.test<CR><ESC>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable<CR><ESC><ESC>
" hard-reset currently open file, to reset things like :set wrap to defaults
nnoremap ,r :e __nonexistantfile__ \| e <C-r>=bufname("%")<CR><CR>
" ,n opens nerdtree if you ever want it
nnoremap ,n :NERDTree<CR>
" ,t inserts the current time, like this:
" September 21, 2013 09:37:34 PM
nnoremap ,t :read !@ 'datetime.datetime.now().strftime("_B _d, _Y _I:_M:_S _p".replace("_", chr(37)))'<CR>
" check what month the currently selected number represents... don't even
" remember why I put this in the global vimrc, lol
vnoremap ,w :!@ 'datetime.datetime(2013, int(inp()), 1).strftime(chr(37) + "B")'<CR>

" set up ctrl-p, a fuzzy file opening tool; very very nice and unobtrusive way
" to quickly open files, autodetects what directory it should start from, so
" it usually doesn't search outside a project's directory
set wildignore+=*.pyc,*.so,.git,.hg,htmlcov,__pycache__
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.cabal-sandbox,Session.vim
let g:ctrlp_open_new_file='v'
let g:ctrlp_lazy_update=50
let g:ctrlp_follow_symlinks=1
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("v")': ['<cr>'],
            \ 'AcceptSelection("e")': ['<c-v>']
            \ }

" ocaml / opam
" merlin completion (https://github.com/the-lambda-church/merlin)
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" taken from https://github.com/SirVer/ultisnips/issues/519#issuecomment-143450416
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
autocmd Filetype tex let g:neocomplete#sources#omni#input_patterns.tex =
    \ '\v\\\a*(ref|cite)\a*([^]]*\])?\{([^}]*,)*[^}]*'

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
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
" set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ghcmod-vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic (https://github.com/scrooloose/syntastic)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_python_pylint_args = ['--errors-only']
let g:syntastic_javascript_checkers = ['jshint']


" this if block from https://bitbucket.org/byronclark/settings
" my favorites from his vimrc
if has("autocmd")
    " remove any previous autocmd settings
    autocmd!

    autocmd BufWritePost ~/.vimrc so ~/.vimrc
    autocmd BufWritePost ~/.vimrc_global so ~/.vimrc
    autocmd BufWritePost ~/dotfiles/files/vimrc so ~/.vimrc
    autocmd BufWritePost ~/.gvimrc so ~/.gvimrc

    " text files don't have a proper filetype
    autocmd BufReadPost *.txt setlocal textwidth=78
    if exists("spell")
        autocmd BufReadPost *.txt setlocal spell spelllang=en_us
    endif

    " gpg encrypted files
    if exists("$KEY")
        autocmd BufNewFile,BufReadPre *.gpg :set secure viminfo= noswapfile nobackup nowritebackup history=0 binary
        autocmd BufReadPost *.gpg :%!gpg -d 2>/dev/null
        autocmd BufWritePre *.gpg :%!gpg -e -r $KEY 2>/dev/null
        autocmd BufWritePost *.gpg u
    endif

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif

endif

set guioptions-=m " turn off menu bar
set guioptions-=T " turn off toolbar

" TODO remove?
" pythony tabs
" set autoindent smarttab
" http://vim.wikia.com/wiki/Converting_tabs_to_spaces
set tabstop=4
set shiftwidth=4
set expandtab
"set softtabstop=2
set backspace=indent,eol,start " defaults to eol,start iirc

" visualize tabs
set list lcs=tab:\.\ 

" line numbers
set number

" highlight the current line on the current window with underline
autocmd VimEnter * set cul
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

set history=10000 " increase history 'cause I like lots of it

set hlsearch  " I like to see my searches
set ignorecase  " ignore case when searching
set smartcase  " except when a capital letter is in the search
set ruler  " show the cursor position all the time
set laststatus=2  " helps show the file name
set incsearch " incremental searches of gloriousness

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" code folding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"fold based on indent
set foldmethod=indent
set foldnestmax=100

" fold settings to create non-obtrusive folding (dave has some even better
" stuff I've been meaning to get from him)
set foldcolumn=0 " no fold indicator column next to line numbers
set foldtext=MyFoldText() " fancy fold text
function! MyFoldText()
    let line = v:foldstart
    let indent = indent(line)
    let indenttext = repeat(" ", indent) " take indent into account when displaying foldtext
    let text = indenttext . foldtext() 
    return text
endfunction
set fillchars="fold:"
" highlight Folded cterm=NONE ctermbg=black ctermfg=darkblue
set nofoldenable " disable folding

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tabular
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neco-ghc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" make default tab completion
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ultisnips
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inoremap <TAB> {{{1
" Next menu item, expand snippet, jump to next placeholder or insert literal tab
let g:UltiSnipsJumpForwardTrigger="<NOP>"
let g:ulti_expand_or_jump_res = 0
function! ExpandSnippetOrJumpForwardOrReturnTab()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<TAB>"
    endif
endfunction
inoremap <expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ "<C-R>=ExpandSnippetOrJumpForwardOrReturnTab()<CR>"
" snoremap <TAB> {{{1
" jump to next placeholder otherwise do nothing
snoremap <buffer> <silent> <TAB>
    \ <ESC>:call UltiSnips#JumpForwards()<CR>

" inoremap <S-TAB> {{{1
" previous menu item, jump to previous placeholder or do nothing
let g:UltiSnipsJumpBackwordTrigger = "<NOP>"
inoremap <expr> <S-TAB>
    \ pumvisible() ? "\<C-p>" :
    \ "<C-R>=UltiSnips#JumpBackwards()<CR>"

" snoremap <S-TAB> {{{1
" jump to previous placeholder otherwise do nothing
snoremap <buffer> <silent> <S-TAB>
    \ <ESC>:call UltiSnips#JumpBackwards()<CR>

" inoremap <CR> {{{1
" expand snippet, close menu or insert newline
let g:UltiSnipsExpandTrigger = "<NOP>"
let g:ulti_expand_or_jump_res = 0
inoremap <silent> <CR> <C-r>=<SID>ExpandSnippetOrReturnEmptyString()<CR>
function! s:ExpandSnippetOrReturnEmptyString()
    if pumvisible()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<C-y>\<CR>"
    endif
    else
        return "\<CR>"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow parentheses
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme (https://github.com/flazz/vim-colorschemes)
"   try new at http://bytefluent.com/vivify/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vim-colorschemes/
set t_Co=256
" note: using Atom terminal color scheme for iTerm2
" (https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/Atom.itermcolors)
colorscheme herald
if has("syntax")
  syntax enable
endif

" for some reason after loading ~/.vimrc with `source ~/.vimrc` inside vim,
" everything gets highlighted. this works around that.
noh
