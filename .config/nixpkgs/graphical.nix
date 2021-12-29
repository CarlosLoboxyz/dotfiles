{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		(st.overrideAttrs (oldAttrs: rec {
			buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
			src = builtins.fetchTarball {
				url = "https://github.com/carlosloboxyz/st/archive/master.tar.gz";
			};
		}))
		xclip
		maim
		xorg.xev
		xdotool
		arandr
		sxiv
		redshift
		dmenu
		firefox
		bspwm
		sxhkd
		numlockx
		tiramisu
		tabbed
		# I put this here because idk where else it should go
		texlive.combined.scheme-full
	];

	home.file.".config/X11/xinitrc".text = ''
		# Setting up the user's D-Bus Daemon
		if test -z "$DBUS_SESSION_BUS_ADDRES"; then
			eval $(dbus-launch --exit-with-session --sh --syntax)
		fi
		systemctl --user import-environment DISPLAY XAUTHORITY
		if command -v dbus-update-activation-environment >/dev/null 2>&1; then
			dbus-update-activation-environment DISPLAY XAUTHORITY
		fi

		xrdb $HOME/.config/X11/xresources &
		
		export XNOTIFY_FIFO="$HOME/.cache/xnotify$DISPLAY.fifo"
		rm -f $XNOTIFY_FIFO
		mkfifo $XNOTIFY_FIFO
		xnotify -b 1 0<>$XNOTIFY_FIFO | sh &

		systemctl --user start picom
		numlockx on

		exec bspwm
	'';

	xresources = {
		extraConfig = "";
		path = "${config.xdg.configHome}/X11/xresources";
		properties = {
			"Xft.dpi" = 96;
			# St
			"st.borderpx" = 16;
			"st.alpha" = ".96";
			"st.font" = "JetBrainsMono Nerd Font-9";
			# Xnotify
			"xnotify.title.font" = "JetBrainsMono Nerd Font-9";
			"xnotify.body.font" = "JetBrainsMono Nerd Font-9";
			"xnotify.background" = "#282828";
			"xnotify.foreground" = "#ebdbb2";
			"xnotify.border" = "#ebdbb2";
			"xnotify.geometry" = "-10+10";
			"xnotify.gravity" = "NE";
			"xnotify.borderWidth" = 2;
			"xnotify.leading" = 3;
			"xnotify.shrink" = true;
			"xnotify.alignment" = "right";
			"xnotify.wrap" = false;
		};
	};

	programs = {
		feh.enable = true;
		tint2 = {
			enable = true;
			settings = ''
				rounded = 0
				border_width = 2
				background_color = #282828 100
				border_color = #ebdbb2 100
				panel_items = TC
				panel_size = 100% 35
				panel_margin = 10 20
				panel_padding = 0 0 0
				panel_background_id = 0
				panel_position = center left vertical
				panel_layer = normal
				panel_monitor = primary
				strut_policy = follow_size
				panel_window_name = tint2
				taskbar_hide_if_empty = 1
				taskbar_hide_inactive_tasks = 1
				taskbar_hide_different_monitor = 1
				taskbar_hide_different_desktop = 1
				taskbar_name = 1
				taskbar_name_padding = 5 5
				taskbar_name_background_id = 1
				taskbar_name_active_background_id = 1
				taskbar_name_font = JetBrainsMono Nerd Font 9
				taskbar_name_active_font_color = #ebdbb2 100
				task_icon = 1
				task_maximum_size = 0 1
				time1_format = %H %M
				time1_font = JetBrainsMono Nerd Font 9
				clock_font_color = #ebdbb2 100
				clock_padding = 0 5
				clock_background_id = 1
			'';
		};
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

	services = {
		picom = {
			enable = true;
			backend = "glx";
			fade = true;
			fadeSteps = [ "0.028" "0.03" ];
			fadeDelta = 5;
			fadeExclude = [ "class_g = 'slop'" ];
			opacityRule = [ "95:class_g = 'Alacritty'" ];
			shadow = true;
			shadowOffsets = [ (-12) (-12) ];
			shadowOpacity = "0.30";
			extraOptions = ''
				use-damage = false;
				xrender-sync-fence = false;
				no-fading-openclose = true;
				no-fading-destroyed-argb = true;
			'';
		};
		unclutter= {
			enable = true;
			timeout = 5;
		};
	};
}
