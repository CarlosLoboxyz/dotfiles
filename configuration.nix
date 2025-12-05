{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Bootloader.
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

  networking.hostName = "chicot"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "altgr-intl";
      options = "caps:swapescape";
    };
    excludePackages = [ pkgs.xterm ];
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # KDE Plasma
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  # Arduino extra ruls for usb
  services.udev.extraRules = ''
    ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="vendor_id", ATTRS{idProduct}=="product_id", MODE="0660", TAG+="uaccess"
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    hplip
  ];

  # autodetect printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.gvfs.enable = true;

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--operator=carlos"
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carlos = {
    isNormalUser = true;
    description = "carlos";
    shell = "/etc/profiles/per-user/carlos/bin/zsh";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
      "libvirtd"
      "adbusers"
      "dialout"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "carlos";

  # Install firefox.
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "browser.toolbars.bookmarks.visibility" = "newtab";
    };
  };

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;

  programs.adb.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  # OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    (lutris.override {
      extraLibraries = pkgs: [ ];
    })

    bruno
    ngrok
    nixfmt-rfc-style
    arduino-ide
    arduino-cli
    compose2nix
    lazygit

    dua
    unzip
    blender
    ardour
    ripgrep
    qpwgraph # pipewire gui tool
    a2jmidid
    gimp3
    imagemagickBig
    tldr
    nmap # network
    obsidian
    wl-clipboard
    htop
    neofetch
    ferdium
    ddcutil
    v4l-utils
    moonlight-qt
    libreoffice-qt
    unrar
    usbutils
    mpv

    vscode
    zed-editor

    # kde theme
    papirus-icon-theme
    papirus-folders

    read-edid
    ffmpeg-full

    picard # musicbrainz (music-tag editor)
    supersonic # navidrone client
    youtube-music

    foliate # epub reader
    dig
    dnslookup
    wget

    # Kde
    plasma-panel-colorizer
    kdePackages.qtstyleplugin-kvantum
  ];

  environment.plasma6.excludePackages = with pkgs; ([
    kdePackages.elisa
    kdePackages.kate
  ]);

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
  ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.virt-manager.enable = true;

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

  programs.git = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    settings = {
      global = {
        log_filter = "^loading";
      };
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
  # services.spice-webdavd.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  security.wrappers = {
    docker-rootlesskit = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service+ep";
      source = "${pkgs.rootlesskit}/bin/rootlesskit";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.enableAskPassword = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
