" Tyler's VIMRC based on: http://dougblack.io/words/a-good-vimrc.html

" Vundle Setup {{{ 
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set runtimepath+=bundle/Vundle.vim,~/.vim/bundle/Vundle.vim
call vundle#begin() 
" Keep plugins between vundle#begin/end.

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Color Schemes...
Plugin 'sjl/badwolf' " https://github.com/sjl/badwolf
Plugin 'altercation/vim-colors-solarized' " https://github.com/altercation/vim-colors-solarized

" VIM Plugins
Plugin 'sjl/gundo.vim' " Super-Undo:  https://github.com/sjl/gundo.vim
Plugin 'kien/ctrlp.vim' " Fuzzy-file/buffer search: https://github.com/kien/ctrlp.vim 
Plugin 'easymotion/vim-easymotion' " Fast motions: https://github.com/easymotion/vim-easymotion
Plugin 'scrooloose/nerdtree' " Tree explorer: https://github.com/scrooloose/nerdtree
Plugin 'bling/vim-airline' " Statusline plugin: https://github.com/bling/vim-airline
Plugin 'tpope/vim-surround' " Surroundings: https://github.com/tpope/vim-surround
Plugin 'editorconfig/editorconfig-vim' "EditorConfig: https://github.com/editorconfig/editorconfig-vim
Plugin 'nvie/vim-flake8' "Flake8: https://github.com/nvie/vim-flake8
Plugin 'archseer/colibri.vim' "Subtle, elegant color scheme: https://github.com/archSeer/colibri.vim
Plugin 'integralist/vim-mypy' "Static type checker MyPy https://github.com/Integralist/vim-mypy

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" }}}

" Leader Shortcuts {{{
let mapleader=","       " leader is comma
" jk is escape
inoremap ht <esc>
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
nmap <leader>nt :NERDTree<CR>
" }}}

" Colors {{{
syntax enable       " enable syntax processing
set background=dark
colorscheme colibri " options: badwolf, desert, solarized, colibri
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h11
" }}}

" Spaces and Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces when using auto-indent (<<, >>. == commands)
set expandtab       " tabs are spaces
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" }}}

" UI Config {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files, such as loading ~/.vim/indent/python.vim
set wildmenu            " visual autocomplete for command menu, used with :e ~/.vim<TAB>
set showmatch           " highlight matching [{()}]
" }}}

" Searching {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
set ignorecase          " case-insensitive searches ...
set smartcase           " ... unless there's a capital letter in the search
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level, see :help foldmethod
" NOTE: zR --> opens all folds, zM --> closes all folds
" }}}

" Movement {{{
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" highlight last inserted text
nnoremap gV `[v`]
let g:EasyMotion_smartcase = 1
" }}}

" Windows {{{
" Shortcuts to change what window is currently active: http://vimcasts.org/episodes/working-with-windows/
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-_> <C-w><C-_>
" }}}

" Ctrl-P Settings {{{
let g:ctrlp_match_window = 'bottom,order:ttb'
" let g:ctrlp_working_path_mode = 0 " Have Ctrl-P honor CWD
let g:ctrlp_working_path_mode = 'ra' " Have Ctrl-P set CWD from .git or CWD
let g:ctrlp_max_files = 80000 " Bump up number of files to search
set wildignore+=*/target/*,*.swp,*.zip     " MacOSX/Linux
" }}}

" Eclim Settings {{{
let g:EclimKeepLocalHistory = 1 " Have eclipse track local history on saves.
let g:EclimCompletionMethod = 'omnifunc' "Let YouCompleteMe give us Eclim code-completion
" }}}

" vim-airline Settings {{{
let g:airline_powerline_fonts = 1
set laststatus=2
" }}}

" Swap Files {{{
set directory^=$HOME/.vim/tmp//  " Store all swap files here: https://vi.stackexchange.com/questions/177/what-is-the-purpose-of-swap-files
" }}}

" Miscellaneous {{{
set hidden              " Don't warm me about hidden buffers: http://vimcasts.org/episodes/working-with-buffers/
set modelines=1         " Check bottom of the file for file-specific settings
au BufEnter /private/tmp/crontab.* setl backupcopy=yes " Allows vim to be used for editing crontab since we use nobackup

" .vimrc Shortcuts {{{
" Source the vimrc file after saving it
if has("autocmd")
    autocmd BufWritePost ~/.vim/vimrc,~/.vimrc source $MYVIMRC
endif

" Edit .vimrc with ",v", with autocmd above to source it on-the-fly: http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly
nmap <leader>v :tabedit $MYVIMRC<CR>
" }}}

" vim:foldmethod=marker:foldlevel=0
