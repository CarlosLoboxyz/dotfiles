path+=$HOME/.local/bin
			
typeset -U path cdpath fpath manpath

fpath=(/usr/share/zsh/site-functions/ $fpath)

# Use viins keymap as the default.
bindkey -v
export KEYTIMEOUT=1

bindkey -a '^[[3~' delete-char

# Editing command lines in vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
	bindkey -M $km -- '-' vi-up-line-or-history
  	for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    		bindkey -M $km $c select-quoted
  	done
  	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    		bindkey -M $km $c select-bracketed
  	done
done

# Surrounding
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes slight start up slowdown
# as all $fpath entries will be traversed again.
autoload -U compinit && compinit

# Check if powerlevel10k exists
if [[ -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"
fi

# Check if theme already exists
if [[ -f "$HOME/.config/zsh/.p10k.zsh" ]]; then
	source "$HOME/.config/zsh/.p10k.zsh"
fi

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="100000"

HISTFILE="/home/carlos/.config/zsh/zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd

if [[ $options[zle] = on ]]; then
  . /usr/share/fzf/completion.zsh
  . /usr/share/fzf/key-bindings.zsh
fi

eval "$(/usr/bin/direnv hook zsh)"

# Aliases
alias -s pdf='zathura'
alias -s {flac,mp3}='mpv --no-audio-display'
alias -s {jpg,png}='feh'
alias ..='cd ..'
alias cp='cp -riv'
alias df='df -h'
alias ip='ip -c=auto'
alias la='ls --color=auto -AhlX --group-directories-first'
alias ls='ls --color=auto -AhX --group-directories-first'
alias mkdir='mkdir -vp'
alias mv='mv -iv'
alias sudo='sudo '
alias tree='tree -C'

# Global Aliases

# Named Directory Hashes
