## Setup Arch Linux with Gnome
Install the following packages to get an unbloated gnome experience
- gnome-shell
- gnome-tweak-tool
- gnome-control-center
- xdg-user-dirs
- gnome-keyring
- networkmanager

## Xorg Configuration
Change capslock to escape key:
```{data-filename="/etc/X11/xorg.conf.d/90-custom-kbd.conf}
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "on"

    Option "XKbOptions" "caps:escape"
EndSection
```

## Shell Packages
- bat
- direnv
- fd
- github-cli
- zsh
- fzf
- zsh-completions
- zsh-theme-powerlevel10k
