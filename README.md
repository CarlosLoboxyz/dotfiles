## Steps to use:
1. Clone this repository: `git clone https://github.com/CarlosLoboxyz/dotfiles.git /etc/nixos`
2. Run `sudo nixos-rebuild switch --flake /etc/nixos`.

## Directory overview:
```graphql
├── configFiles
│   ├── nvim 
│   ├── tmux
│   ├── scripts # Custom shell scripts that go inside ~/.local/share/scripts
│   ...
├── configuration.nix
├── flake.nix
├── hardware-configuration.nix
├── home.nix
└── README.md
```
