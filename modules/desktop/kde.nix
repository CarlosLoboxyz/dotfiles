{ pkgs, config, ... }:

{
  # === Display Manager & Desktop ===
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "altgr-intl";
      options = "caps:swapescape";
    };
    excludePackages = [ pkgs.xterm ];
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs; ([
    kdePackages.elisa
    kdePackages.kate
  ]);

  # Environment Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # === Audio (Pipewire) ===
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # === Fonts ===
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
  ];

  # === Desktop Apps ===
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "browser.toolbars.bookmarks.visibility" = "newtab";
    };
  };

  environment.systemPackages = with pkgs; [
    brave
    obsidian
    libreoffice-qt
    foliate

    # Audio/Video Tools
    qpwgraph
    a2jmidid
    mpv
    picard
    supersonic
    youtube-music
    ffmpeg-full
    wl-clipboard

    # KDE Theming
    plasma-panel-colorizer
    kdePackages.qtstyleplugin-kvantum
    papirus-icon-theme
    papirus-folders
  ];
}
