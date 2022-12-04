source $HOME/.config/nvim/plugins/declaration.vim
source $HOME/.config/nvim/plugins/gruvbox.vim

" Options
set hidden
set nowrap
set encoding=utf-8
"set pumheight=10
set colorcolumn=80
set ruler
"set cmdheight=2
set iskeyword+=-
set splitbelow
set splitright
set conceallevel=0
set number
set cursorline
set showtabline=2
set laststatus=2
set noshowmode
set updatetime=300
set timeoutlen=500
set formatoptions-=cro
set clipboard=unnamedplus
set undofile
set scrolloff=5
set incsearch
set signcolumn=yes

" Indentation using tabs
set noexpandtab
set softtabstop=0
set shiftwidth=4
set tabstop=4
set copyindent
set preserveindent

" Keybindings
nnoremap <space>/ :Commentary<CR>
vnoremap <space>/ :Commentary<CR>

nnoremap <space>t :NvimTreeToggle<CR>
nnoremap <space>T :NvimTreeFocus<CR>

" Shift + J/K moves selected lines down/up in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Save and restore manual folds when we exit a file
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END
