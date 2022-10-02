ZDOTDIR=$HOME/.config/zsh

export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export LESSHISTFILE="-"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$HOME/.config/X11/xinitrc"
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS="--border --info=inline --height=100 --layout=default"
export FZF_CTRL_T_OPTS="--preview 'bat --line-range :50 {}'"
export FZF_ALT_C_COMMAND="fd --type d . --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
			
# Make system functions available to zsh
() {
  setopt LOCAL_OPTIONS CASE_GLOB EXTENDED_GLOB

  local system_fpaths=(
      # Package default
      /usr/share/zsh/site-functions(/-N)

      # Debian
      /usr/share/zsh/functions/**/*(/-N)
      /usr/share/zsh/vendor-completions/(/-N)
      /usr/share/zsh/vendor-functions/(/-N)
  )
  fpath=(${fpath} ${system_fpaths})
}
