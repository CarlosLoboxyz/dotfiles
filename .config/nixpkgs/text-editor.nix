{ config, pkgs, ... }:

let
	vim-indentguides = pkgs.vimUtils.buildVimPlugin {
		name = "vim-indentguides";
		src = pkgs.fetchFromGitHub {
			owner = "thaerkh";
			repo = "vim-indentguides";
			rev = "3152f3a0604089d545983b72e7cb676898bb7da1";
			sha256 = "08dvkjvigwpqvpbzavlfqcq7gjimfm1941hgjbpnqap7apc12lwp";
		};
	};
in

{
	programs.neovim = {
		enable = true;
		viAlias = true;
		plugins = with pkgs.vimPlugins; [
			vim-nix
			gruvbox-community
			vim-commentary
			{
			  plugin = vim-indentguides;
			  config = "let g:indentguides_tabchar = '│'";
			}
			auto-pairs
			fzf-vim
			vim-polyglot
			goyo-vim
			limelight-vim
			vim-fugitive
		];
		extraConfig = ''
			" Options
			set exrc
			set number
			set nowrap
			set nohlsearch
			set nobackup
			set noswapfile
			set undofile
			set noshowmode
			set laststatus=1
			set showtabline=2
			set splitbelow
			set splitright
			set colorcolumn=80

			" Indentation using tabs
			set noexpandtab
			set softtabstop=0
			set shiftwidth=4
			set tabstop=4
			set copyindent
			set preserveindent

			" Editor theme
			set termguicolors
			set background=dark
			colorscheme gruvbox
			hi Normal guibg=None ctermbg=None

			" Shift + J/K moves selected lines down/up in visual mode
			vnoremap J :m '>+1<CR>gv=gv
			vnoremap K :m '<-2<CR>gv=gv

			" Goyo & Limelight
			autocmd! User GoyoEnter Limelight
			autocmd! User GoyoLeave Limelight!
		'';
	};
}
