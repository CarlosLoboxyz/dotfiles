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
			vim-indentguides
			auto-pairs
		];
		extraConfig = ''
			set laststatus=0
			set showtabline=2
			set splitbelow
			set splitright
			set noswapfile
			set nobackup
			set undofile
			set number
			set nowrap
			set noexpandtab
			set copyindent
			set preserveindent
			set softtabstop=0
			set shiftwidth=4
			set tabstop=4
			set termguicolors
			set background=dark
			colorscheme gruvbox
		'';
	};
}
