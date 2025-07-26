{ config, pkgs, ... }:

{
	home-manager.users.carlos = { pkgs, ... }: {
		programs.tmux = {
			enable = true;
			extraConfig = ''
				# Set terminal colors
				set-option -sa terminal-overrides ",xterm*:Tc"

				# Start windows and panes at 1, not 0
				set -g base-index 1
				set -g pane-base-index 1
				set-window-option -g pane-base-index 1
				set-option -g renumber-windows on

				# switch windows alt+number
				bind-key -n M-1 select-window -t 1
				bind-key -n M-2 select-window -t 2
				bind-key -n M-3 select-window -t 3
				bind-key -n M-4 select-window -t 4
				bind-key -n M-5 select-window -t 5
				bind-key -n M-6 select-window -t 6
				bind-key -n M-7 select-window -t 7
				bind-key -n M-8 select-window -t 8
				bind-key -n M-9 select-window -t 9

				# Clipboard for wayland
				set -s copy-command 'wl-copy'

				# Set mouse support
				set -g mouse on

				# if run as "tmux attach", create a session if one does not already exist
				# new-session -n $HOST

				# Map "lalt+f" as the main prefix
				set-option -g prefix M-f
				unbind C-b
				bind M-f send-prefix

				# Navigation
				bind -n M-h select-pane -L
				bind -n M-j select-pane -D
				bind -n M-k select-pane -U
				bind -n M-l select-pane -R

				# New key table for navigation
				bind -Troot M-w switch-client -TPaneDo
				# New key table for session
				bind -Troot M-s switch-client -TSessionDo

				# Resize panes
				bind -TPaneDo -r J resize-pane -D 3
				bind -TPaneDo -r K resize-pane -U 3
				bind -TPaneDo -r L resize-pane -R 3
				bind -TPaneDo -r H resize-pane -L 3
				# Open new panes
				unbind %
				unbind '"'
				bind -TPaneDo l split-window -h -c "#{pane_current_path}"
				bind -TPaneDo j split-window -v -c "#{pane_current_path}"

				# Reload config file
				unbind r
				bind r  source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux.conf"

				# Opening a new window
				unbind t
				bind t new-window -c "#{pane_current_path}"
				# Opening a new session
				unbind T
				bind T new-session

				# Rename & Close Panes
				bind -TPaneDo N command-prompt "rename-window '%%'"
				bind -TPaneDo q kill-pane

				# Rename & Close Session
				bind -TSessionDo N command-prompt "rename-session '%%'"
				bind -TSessionDo q kill-session

				# vi mode for searches
				set-window-option -g mode-keys vi

				# fix escape delay
				set -s escape-time 0

				# Alt-Tab to switch between windows
				bind-key -n M-] next-window
				bind-key -n M-[ previous-window
				bind-key -n M-Tab last-window

				# Gruvbox
				source-file ~/.config/tmux/colorschemes/gruvbox.conf

				# Popups
				bind-key -n M-m display-popup -E "ncmpcpp"
				bind-key -n M-M display-popup -E "neomutt"
				bind-key -n M-t run-shell "~/.config/tmux/scripts/launcher.sh"

				# Persistence popups
				bind-key -n M-y run-shell "~/.config/tmux/scripts/popup.sh yt"
				bind-key -n M-o run-shell "~/.config/tmux/scripts/popup.sh ranger"
				# Remove status bar for the popup session
				set-hook -g session-created "if '[ #{session_name} = popup ]' 'set status off'"

				# Hyperlinks
				set -ga terminal-features ",*:hyperlinks"

				# Show or hide status bar
				unbind h
				bind-key h "set -g status off"
				unbind H
				bind-key H "set -g status 3"

				# Switch client between sessions
				bind-key -n M-n switch-client -n
				bind-key -n M-p switch-client -p

				# Copy mode made easier
				unbind /
				bind-key / copy-mode

				# Scrollback limit
				set-option -g history-limit 100000
				'';
		};
		xdg.configFile."tmux/colorschemes/gruvbox.conf".text = ''
			### theme settings ###

			# alignment settings
			set-option -g status-justify centre

			# window separators
			set-option -wg window-status-separator ""

			# monitor window changes
			set-option -wg monitor-activity on
			set-option -wg monitor-bell on

			# set statusbar update interval
			set-option -g status-interval 5

			# pane border
			set-option -g pane-active-border-style fg="#FE8019"
			set-option -g pane-border-style fg="#3C3836"

			# message info
			set-option -g message-style bg="#FE8019",fg="#3C3836"

			# writing commands inactive
			set-option -g message-command-style bg="#A89984",fg="#3C3836"

			# pane number display
			set-option -g display-panes-active-colour "#FE8019"
			set-option -g display-panes-colour "#3C3836"

			# clock
			set-option -wg clock-mode-colour "#FE8019"

			# copy mode highlighting
			%if #{>=:#{version},3.2}
				set-option -wg copy-mode-match-style "bg=#A89984,fg=#3C3836"
				set-option -wg copy-mode-current-match-style "bg=#FE8019,fg=#3C3836"
			%endif

			# Add a blank status bar for a bit more space
			set -g status 2
			set -g status 3
			# set -g status 4

			set -g status-style bg=terminal,fg="#a89984"

			# # Empty line
			# set -g status-format[0] ""
			#
			# # System tray line
			# set -g status-format[1] "#[align=right] #[fg=blue]#[bg=#3c3836]  #[fg=#a89984]#(~/.config/tmux/scripts/connection.sh)▕ #[fg=green]#[bg=#3c3836] #[fg=#a89984]#(~/.config/tmux/scripts/battery.sh)%▕ #[fg=yellow]#[bg=#3c3836] #[fg=#a89984]%H:%M "
			#
			# # Tmux info
			# set -g status-format[2] "#[align=left]#[bg=#3c3836, fg=#a89884] #{=/20/...:session_name} "
			# set -ag status-format[2] "#[align=absolute-centre]#[bg=#3c3836, fg=#a89884]#{W:#[bg=#3c3836] #I:#(~/.config/tmux/scripts/icons/icons.sh #W)#[fg=#a89884]#W#{?window_end_flag,,▕},#[bg=#504945] #I:#(~/.config/tmux/scripts/icons/icons.sh #W)#[fg=#a89884]#W#{?window_end_flag,,▕}} "
			#
			# set -ag status-format[2] "#[align=right]#[bg=#A89984, fg=#3C3836]#{?client_prefix,#[bg=#fe8019],#[bg=#A89984]}#[bg=#3c3836]#[fg=#a89984] #{user}#[fg=magenta]@#[fg=#a89984]#{host} "
			#
			# # Empty line
			# set -g status-format[3] ""
			
			####### --------- test ----------- ########
			
			# Empty line
			# set -g status-format[0] ""
			
			# System tray line
			set -g status-format[0] "#[align=left]#[fg=orange]#[bg=#3c3836]  #[fg=#a89984] #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD) "
			set -ag status-format[0] "#[align=right] #[fg=blue]#[bg=#3c3836] #[fg=#a89984]#(~/.config/tmux/scripts/connection.sh)▕ #[fg=green]#[bg=#3c3836] #[fg=#a89984]#(~/.config/tmux/scripts/battery.sh)%▕ #[fg=yellow]#[bg=#3c3836] #[fg=#a89984]%H:%M "
			
			# Tmux info
			set -g status-format[1] "#[align=left]#[bg=#3c3836, fg=#a89884] #{=/20/...:session_name} "
			set -ag status-format[1] "#[align=absolute-centre]#[bg=#3c3836, fg=#a89884]#{W:#[bg=#3c3836] #I:#(~/.config/tmux/scripts/icons/icons.sh #W)#[fg=#a89884]#W#{?window_end_flag,,▕},#[bg=#504945] #I:#(~/.config/tmux/scripts/icons/icons.sh #W)#[fg=#a89884]#W#{?window_end_flag,,▕}} "	
			set -ag status-format[1] "#[align=right]#[bg=#A89984, fg=#3C3836]#{?client_prefix,#[bg=#fe8019],#[bg=#A89984]}#[bg=#3c3836]#[fg=#a89984] #{user}#[fg=magenta]@#[fg=#a89984]#{host} "
			
			# Empty line
			set -g status-format[2] ""
		'';
	};
}
