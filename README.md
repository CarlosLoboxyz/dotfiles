__*Steps to use:*__
1. Install [home-manager](https://github.com/nix-community/home-manager#installation).
2. Copy the files inside `.config/nixpkgs` to your pertinent location.
3. Run `home-manager switch`.

__*Directory overview*__
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
└── README.md
```
