" init.vim
" Maintainer: 1noro <ppuubblliicc@protonmail..com> 

" Map leader to space
let mapleader=" "


" # PLUGINS -------------------------------------------------------------------
" Install vim-plug: https://github.com/junegunn/vim-plug#unix-linux
call plug#begin('~/.config/nvim/plugged')
    " File system explorer
    Plug 'preservim/nerdtree'
    " True snippet and additional text editing support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Shows a git diff in the sign column
    Plug 'airblade/vim-gitgutter'
    " Fix CursorHold performance
    Plug 'antoinemadec/FixCursorHold.nvim'
    " A collection of language packs for Vim (programming)
    Plug 'sheerun/vim-polyglot'
    " Display thin vertical lines at each indentation level
    Plug 'Yggdroot/indentLine'
    " Telescope dependence
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Highly extendable fuzzy finder over lists
    Plug 'nvim-telescope/telescope.nvim'
    " A light and configurable statusline/tabline
    Plug 'itchyny/lightline.vim'
    " The premier Vim plugin for Git (lightline dependence)
    Plug 'tpope/vim-fugitive'
    " Gruvbox themes
    Plug 'morhetz/gruvbox'
    Plug 'shinchu/lightline-gruvbox.vim'
    " Toggle comments with <leader>c<leader>
    Plug 'scrooloose/nerdcommenter'
    " Displays a popup with possible key bindings of the command you started 
    Plug 'folke/which-key.nvim'
    " Personal wiki for Vim
    "Plug 'vimwiki/vimwiki'
    " Git Blame for statusline
    Plug 'zivyangll/git-blame.vim'
    " Spell check (markdown & plain text)
    "Plug 'rhysd/vim-grammarous'
call plug#end()

lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" # BASICS -------------------------------------------------------------------- 
syntax on
set encoding=utf-8
set number relativenumber
set history=200 " Keep 200 lines of command line history
set wildmenu " Display completion matches in a status line
set display=truncate " Show @@@ in the last line if it is truncated (?)

" Set window title auto
autocmd BufEnter * let &titlestring = "nvim: " . expand("%:t")

" Mode info like '-- INSERT --' is unnecessary anymore because the mode
" information is displayed in the statusline
set noshowmode

" Show a few lines of context around the cursor. Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=0

" Share clipboard install wl-copy for wyland or xclip for X11
set clipboard+=unnamedplus

" Enable autocompletion
set wildmode=longest,list,full
"set wildmode=full:lastused " another option

" Don't use Ex mode, use Q for formatting (revert with ":unmap Q")
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
" (revert with ":iunmap <C-U>")
" (i don't understand)
inoremap <C-U> <C-G>u<C-U>

" Convenient command to see the difference between the current buffer 
" and the file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Higlight current word occurences
"set hlsearch
"nnoremap * *N
"nnoremap _ :noh<CR>
"set nohlsearch

" Add " or ' to selected text in visual mode
vnoremap "" c"<c-r>""<Esc>
vnoremap '' c'<c-r>"'<Esc>
"vnoremap `` c`<c-r>"` " search for an appropriate bindig

" Add blank line below (pending modification)
nnoremap _ o<Esc>k

" Remove trailing spaces (I don't know what exactly it removes)
command RmTrail :%s/\s\+$//e

" Status line always (https://neovim.io/doc/user/options.html#'laststatus')
set laststatus=2

" Ignore case in searches
set ignorecase
" Override the 'ignorecase' option if the search pattern contains upper
" case characters. Only used when the search pattern is typed and
" 'ignorecase' option is on
set smartcase

" Start directly in insert mode (i think it doesn't work)
"autocmd TermOpen * startinsert

" Remap increase number
nnoremap <C-c> <C-a>

" Keeping it centered (i think it doesn't work)
nnoremap n nzzzv
nnoremap N Nzzzv
"nnoremap J mzJ`z

" Save and exit with <leader>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>


" # COLORSCHEME ---------------------------------------------------------------
colorscheme gruvbox


" # SHOW WHITESPACES ----------------------------------------------------------
" (https://stackoverflow.com/questions/12534313/vim-set-list-as-a-toggle-in-vimrc)
" (https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character)
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set listchars=eol:¬,tab:--,trail:~,extends:>,precedes:<,space:·
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>


" # WORD WRAP -----------------------------------------------------------------
" Dont wrap by default
set nowrap
" Break indent (i think it doesn't work)
set breakindent
set showbreak=>>
" Soft word wrap
"set wrap linebreak
set linebreak
" Word wrap (toggle)
noremap <F6> :set wrap!<CR>
inoremap <F6> <C-o>:set wrap!<CR>
cnoremap <F6> <C-c>:set wrap!<CR>

" Disables automatic completion on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o 

" Spell-check set to <leader>o, 'o' for 'orthography'
map <leader>o :setlocal spell! spelllang=es_es,en_us<CR>


" # INDENTATION ---------------------------------------------------------------
" Spaces instead of tabs
" - tabstop:     Width of tab character
" - softtabstop: Fine tunes the amount of white space to be added
" - shiftwidth   Determines the amount of whitespace to add in normal mode
" - expandtab:   When this option is enabled, vi will use spaces instead of tabs
filetype plugin indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


" # VERTICAL RULER ------------------------------------------------------------
" Set ruler at line 80 and toggle it with <F4>
"set colorcolumn=80
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
nnoremap <F4> :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>


" # NERDTREE ------------------------------------------------------------------
" NERDTreeToggle when <F3>
noremap <F3> :NERDTreeToggle<CR>
"inoremap <F3> <C-o>:NERDTreeToggle<CR>
"cnoremap <F3> <C-c>:NERDTreeToggle<CR>

" NERDTree show hidden files by default
let NERDTreeShowHidden=1


" # LINE NUMBERS --------------------------------------------------------------
" Toggle line numbers
nnoremap <F2> :set nonumber! norelativenumber!<CR>
"inoremap <F2> <C-o> :set nonumber! norelativenumber!<CR>
"cnoremap <F2> <C-c> :set nonumber! norelativenumber!<CR>


" # WINDOW SPLIT --------------------------------------------------------------
" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-Right> <C-W><C-L>
nnoremap <C-Left> <C-W><C-H>

" Splits open at the bottom and right
set splitright splitbelow


" # SYNTAX HIGHLIGHT ----------------------------------------------------------
" Map extensions to other syntax
autocmd BufNewFile,BufRead *.env.template set syntax=sh
autocmd BufNewFile,BufRead *.env.tmpl set syntax=sh
autocmd BufNewFile,BufRead *.zsh set syntax=sh


" # MOUSE ---------------------------------------------------------------------
" In many terminal emulators the mouse works just fine. By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc
if has('mouse')
    if &term =~ 'xterm'
        set mouse=a
    else
        set mouse=nvi
    endif
endif


" # COC -----------------------------------------------------------------------
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Enable highlight current symbol on CursorHold:
autocmd CursorHold * silent call CocActionAsync('highlight')

" In milliseconds, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100

" Use <C-r> to trigger completion
inoremap <silent><expr> <C-r> coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Coc auto-install extensions
let g:coc_global_extensions = [ 
    \ 'coc-json',
    \ 'coc-sh',
    \ 'coc-diagnostic',
    \ 'coc-yaml',
    \ 'coc-html',
    \ 'coc-sql',
    \ 'coc-groovy',
    \ 'coc-docker']

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected) " Conflicto con telescope

" # TELESCOPE -----------------------------------------------------------------
" Find files using Telescope command-line sugar
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fa <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep hidden=true<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>

" # LIGHTLINE -----------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" # GIT BLAME -----------------------------------------------------------------
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
