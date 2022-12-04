" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    Plug 'sheerun/vim-polyglot' " Better Syntax Support
    Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{'
    Plug 'gruvbox-community/gruvbox' " Color scheme
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'feline-nvim/feline.nvim'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'junegunn/fzf.vim'
    Plug 'mattn/emmet-vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'xiyaowong/nvim-transparent'
    Plug 'kyazdani42/nvim-web-devicons'

call plug#end()
