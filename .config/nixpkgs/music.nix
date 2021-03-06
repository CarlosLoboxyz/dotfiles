{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		mpc_cli
	];

	programs = {
		mpv.enable = true;
		ncmpcpp = {
			enable = true;
			package = pkgs.ncmpcpp.override { visualizerSupport = true; };
			bindings = [
				{ key = "j"; command = "scroll_down"; }
				{ key = "k"; command = "scroll_up"; }
				{ key = "h"; command = "previous_column"; }
				{ key = "l"; command = "next_column"; }
				{ key = "J"; command = "volume_down"; }
				{ key = "K"; command = "volume_up"; }
				{ key = "g"; command = "move_home"; }
				{ key = "G"; command = "move_end"; }
			];
			settings = {
				lyrics_directory = "${config.services.mpd.musicDirectory}/lyrics";
				allow_for_physical_item_deletion = "yes";
				visualizer_in_stereo = "yes";
				visualizer_data_source = "/tmp/mpd.fifo";
				visualizer_output_name = "my_fifo";
				visualizer_look = "22";
				visualizer_color = "blue, cyan, green, yellow, magenta, red, black";
				message_delay_time = "2";
				playlist_shorten_total_times = "yes";
				playlist_display_mode = "classic";
				playlist_editor_display_mode = "columns";
				browser_display_mode = "columns";
				search_engine_display_mode = "columns";
				autocenter_mode = "yes";
				mouse_support = "yes";
				centered_cursor = "no";
				user_interface = "classic";
				follow_now_playing_lyrics = "yes";
				display_bitrate = "no";
				external_editor = "nvim";
				progressbar_elapsed_color = "white";
				header_visibility = "yes";
				statusbar_visibility = "yes";
				titles_visibility = "yes";
				statusbar_color = "white";
				now_playing_prefix = "$b$1";
				now_playing_suffix = "$8$/b";
				song_columns_list_format = "(6)[]{} (23)[red]{a} (26)[yellow]{t|f} (40)[green]{b} (4)[blue]{l}";
				song_list_format = "$1> $2%a$8 - $3%b - $8%t $R $3%l  ";
				song_status_format = "$b$7♫ $2%a $8- $3%b $8- $8%t ";
				song_window_title_format = " {%a} - {%t}";
			};
		};
	};

	services.mpd = {
		enable = true;
		musicDirectory = "${config.home.homeDirectory}/Music";
		dataDir = "${config.xdg.configHome}/mpd";
		extraConfig = ''
			auto_update "yes"
			restore_paused "yes"
			audio_output {
				type "pulse"
				name "Pulseaudio"
			}
			audio_output {
				type "fifo"
				name "my_fifo"
				path "/tmp/mpd.fifo"
				format "44100:16:2"
			}
		'';
	};
}
