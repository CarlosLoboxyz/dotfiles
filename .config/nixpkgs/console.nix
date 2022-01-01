{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [
		fd
		ranger
	];

	home.file.".config/fd/ignore".text = "Music\n.mozilla\n.cache";

	programs = {
		direnv = {
			enable = true;
			enableZshIntegration = true;
			#config = {};
			#nix-direnv.enable = true;
			#stdlib = true;
		};
		newsboat = {
			enable = true;
			urls = [
				{ tags = []; url = "https://lukesmith.xyz/rss.xml"; }
			];
		};
		zsh = {
			enable = true;
			autocd = true;
			defaultKeymap = "viins";
			dotDir = ".config/zsh";
			envExtra = ''
				export LESSHISTFILE="-"
				export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
				export XINITRC="$HOME/.config/X11/xinitrc"
				export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
			'';
			initExtraFirst = ''
				path+=$HOME/.local/bin
			'';
			initExtra = ''
			  source "${config.xdg.configHome}/zsh/.p10k.zsh"
			'';
			profileExtra = ''
				# Start the window manager
				if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
					exec startx $XINITRC
				fi
			'';
			history = {
				expireDuplicatesFirst = true;
				ignoreDups = true;
				ignoreSpace = true;
				path = "${config.xdg.configHome}/zsh/zsh_history";
				save = 100000;
				share = true;
			};
			plugins = [
				{
					name = "powerlevel10k";
					src = pkgs.zsh-powerlevel10k;
					file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
				}
			];
			shellAliases = {
				sudo = "sudo ";
				ls = "ls --color=auto -AhX --group-directories-first";
				la = "ls --color=auto -AhlX --group-directories-first";
				ip = "ip -c=auto";
				mv = "mv -iv";
				cp = "cp -riv";
				mkdir = "mkdir -vp";
				df = "df -h";
				tree = "tree -C";
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
			ignores = [
				"*.sh"
				"ani-cli"
			];
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
			};
		};
		fzf = {
			enable = true;
			enableZshIntegration = true;
			defaultCommand = "fd -H --type f --color=never";
			defaultOptions = [
				"--border" "--info=inline" "--height=100" "--layout=default" 
			];
			#changeDirWidgetCommand = "";
			#changeDirWidgetOptions = [  ];
			fileWidgetCommand = "fd -H --type f --color=never";
			fileWidgetOptions = [
				"--border" "--info=inline" "--height=100" "--layout=default" "--preview 'bat --line-range :50 {}'"
			];
		};
	};
}
