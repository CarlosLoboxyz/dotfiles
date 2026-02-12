{ pkgs, ... }:

{
  # === Nix Configuration ===
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  # === Boot & Hardware ===
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.i2c.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # === Networking & Time ===
  networking.networkmanager.enable = true;
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--operator=carlos" ];
  };
  time.timeZone = "America/Caracas";

  # === Locale ===
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  # === User Configuration ===
  programs.zsh.enable = true;

  users.users.carlos = {
    isNormalUser = true;
    description = "carlos";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
      "libvirtd"
      "adbusers"
      "dialout"
    ];
    packages = [];
  };

  # Automatic Login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "carlos";

  # === Core Services ===
  services.gvfs.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    hplip
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  programs.ssh = {
    enableAskPassword = true;
    startAgent = true;
  };
  security.polkit.enable = true;

  # === Essential Packages ===
  environment.systemPackages = with pkgs; [
    wget
    dig
    dnslookup
    unzip
    unrar
    ripgrep
    fd
    tldr
    htop
    neofetch
    dua

    nixfmt-rfc-style
    usbutils
  ];

  # === Global Editor (Minimal Neovim) ===
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set number
        colorscheme pablo
      '';
    };
  };

  programs.git.enable = true;
}
