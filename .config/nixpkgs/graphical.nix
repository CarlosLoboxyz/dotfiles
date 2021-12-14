{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		(st.overrideAttrs (oldAttrs: rec {
			buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
			src = builtins.fetchTarball {
				url = "https://github.com/carlosloboxyz/st/archive/master.tar.gz";
			};
		}))
		numlockx
		xorg.xev
		xdotool
		tint2
		sxhkd
		arandr
		sxiv
		redshift
		dmenu
		firefox
	];

	xresources = {
		extraConfig = "";
		path = "${config.xdg.configHome}/X11/Xresources";
		properties = {
			"Xft.dpi" = 96;
			"st.borderpx" = 16;
			"st.alpha" = ".96";
			"st.font" = "JetBrainsMono Nerd Font-9";
		};
	};

	programs = {
		feh.enable = true;
		zathura = {
			enable = true;
			extraConfig = ''
				map r reload
				map R rotate
				map K zoom in
				map J zoom out
				map i recolor
				map t toggle_statusbar
			'';
			options = {
				statusbar-h-padding = 0;
				statusbar-v-padding = 0;
				page-padding = 1;
				selection-clipboard = "clipboard";
				default-bg = "#282828";
				statusbar-bg = "#282828";
				inputbar-bg = "#282828";
				guioptions = "no";
			};
		};
	};

	services.picom = {
		enable = true;
		backend	= "glx";
		experimentalBackends = true;
		fade = true;
		fadeSteps = [ "0.028" "0.03" ];
		fadeDelta = 5;
		fadeExclude = [ "class_g = 'slop'" ];
		opacityRule = [ "95:class_g = 'Alacritty'" ];
		shadow = true;
		shadowOffsets = [ (-12) (-12) ];
		shadowOpacity = "0.30";
		vSync = true;
		extraOptions = ''
			no-fading-openclose = true;
			no-fading-destroyed-argb = true;
		'';
	};
}
