""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VUNDLE (https://github.com/gmarik/Vundle.vim#about)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'plasticboy/vim-markdown'
Plugin 'pbrisbin/vim-syntax-shakespeare'

call vundle#end()
filetype plugin indent on  " required

" Brief help
" :PluginList          - list configured bundles
" :PluginInstall(!)    - install (update) bundles
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused bundles
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.

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

" turn filetype detection on
filetype plugin on
filetype indent on

set guioptions-=m " turn off menu bar
set guioptions-=T " turn off toolbar

" pythony tabs
set autoindent smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start " defaults to eol,start iirc

" line numbers
set number

" highlight the current line on the current window with underline
autocmd VimEnter * set cul
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

set history=50000 " increase history 'cause I like lots of it

set hlsearch  " I like to see my searches
set ignorecase  " ignore case when searching
set smartcase  " except when a capital letter is in the search
set ruler  " show the cursor position all the time
set laststatus=2  " helps show the file name
set incsearch " incremental searches of gloriousness

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FOLDING
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
" COLORSCHEME (https://github.com/chriskempson/base16-vim)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme base16-shapeshifter
if has("syntax")
  syntax enable
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
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
set wildmode=longest:full,full
set wildmenu

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
set wildignore=*.pyc,*.so,.git,.hg,htmlcov,__pycache__
let g:ctrlp_open_new_file='v'
let g:ctrlp_lazy_update=50
let g:ctrlp_follow_symlinks=1
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("v")': ['<cr>'],
            \ 'AcceptSelection("e")': ['<c-v>']
            \ }

" for some reason after loading ~/.vimrc with `source ~/.vimrc` inside vim,
" everything gets highlighted. this works around that.
noh
