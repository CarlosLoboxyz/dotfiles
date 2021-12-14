{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		fd
	];

	programs = {
		newsboat.enable = true;
		zsh = {
			enable = true;
			autocd = true;
			defaultKeymap = "viins";
			dotDir = ".config/zsh";
			envExtra = ''
				export LESSHISTFILE="-"
				export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
			'';
			history = {
				expireDuplicatesFirst = true;
				ignoreDups = true;
				ignoreSpace = true;
				path = "${config.xdg.configHome}/zsh/zsh_history";
				save = 100000;
				share = true;
			};
			shellAliases = {
				sudo = "sudo ";
				".." = "cd ..";
				"-s pdf" = "zathura";
				"-s {flac,mp3}" = "mpv --no-audio-display";
				"-s {jpg,png}" ="feh";
			};
		};
		git = {
			enable = true;
			userName = "Carlos Lobo";
			userEmail = "86011416+CarlosLoboxyz@users.noreply.github.com";
			extraConfig = {
				init.defaultBranch = "main";
			};
		};
		gh = {
			enable = true;
			enableGitCredentialHelper = true;
			settings = {
				git_protocol = "ssh";
			};
		};
		bat = {
			enable = true;
			config = {
				color = "always";
				theme = "gruvbox-dark";
			};
		};
		fzf = {
			enable = true;
			enableZshIntegration = true;
			defaultCommand = "fd -H --type f --color=never";
			defaultOptions = [
				"--border" "--info=inline" "--height=100" "--layout=default" 
				"--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
			];
			#changeDirWidgetCommand = "";
			#changeDirWidgetOptions = [  ];
			fileWidgetCommand = "fd -H --type f --color=never";
			fileWidgetOptions = [
				"--border" "--info=inline" "--height=100" "--layout=default" "--preview 'bat --line-range :50 {}'"
				"--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
			];
		};
	};
}
