## Steps to use:
1. Clone this repository:
	`git clone https://github.com/CarlosLoboxyz/dotfiles.git ./dotfiles`
2. Install [home-manager](https://github.com/nix-community/home-manager#installation).
3. Create a symlink to your config folders:
	```shell
	ln -s ./dotfiles/.config/* ~/.config/
	ln -s ./dotfiles/.local/bin/ ~/.local/bin

	# Run as root
	ln -s ./dotfiles/etc/nixos/ /etc/nixos
	```
4. Run `home-manager switch`.

## Directory overview:
```graphql
├── .config
│   ├── bspwm # WM config dir
│   │   └── bspwmrc
│   ├── nixpkgs
│   │   ├── console.nix
│   │   ├── graphical.nix
│   │   ├── home.nix # home-manager main file.
│   │   ├── music.nix
│   │   └── text-editor.nix
│   └── sxhkd # Hot key deamon config dir.
│       └── sxhkdrc
├── etc
│   └── nixos # Nixos configuration dir.
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── .local
│   └── bin # Scripts folder
│       └── ...
└── README.md
```
