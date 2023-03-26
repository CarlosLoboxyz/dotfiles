export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"

export EDITOR="nvim"
export VISUAL="nvim"

# cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.histfile"
export HISTSIZE=10000
export SAVEHIST=100000

# wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS="--border --info=inline --height=100 --layout=default"
export FZF_CTRL_T_OPTS="--preview 'bat --line-range :50 {}'"
export FZF_ALT_C_COMMAND="fd --type d . --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# other
export LESS=-R
