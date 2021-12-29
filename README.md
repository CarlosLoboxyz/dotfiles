## Steps to use:
1. Install [home-manager](https://github.com/nix-community/home-manager#installation).
2. Copy the files inside `.config/nixpkgs` to your pertinent location.
3. Run `home-manager switch`.

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
