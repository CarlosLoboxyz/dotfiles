{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/default.nix
    ../../modules/desktop/kde.nix
    ../../modules/dev/default.nix   

    inputs.home-manager.nixosModules.home-manager
  ];

  # === Host Identity ===
  networking.hostName = "nixos-lobo";
  system.stateVersion = "25.05";

  # === Machine-Specific Networking ===
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  
  networking.firewall = {
    allowedUDPPorts = [ 53 67 ]; # DNS, DHCP
    allowedTCPPorts = [ 53 ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # === Machine-Specific Services ===
  
  services.openssh.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # === Machine-Specific Packages ===
  environment.systemPackages = with pkgs; [
    gemini-cli
    
    gimp3
    imagemagickBig
    
    keychain
    kdePackages.sddm-kcm
  ];

  # === User Configuration ===
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.carlos = import ../../modules/home/default.nix;
  };
}
