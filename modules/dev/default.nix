{ pkgs, config, ... }:

{
  # === Docker & Virtualization ===
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  # Docker Rootless Wrapper
  security.wrappers.docker-rootlesskit = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_bind_service+ep";
    source = "${pkgs.rootlesskit}/bin/rootlesskit";
  };

  # === Tools ===
  programs.direnv = {
    enable = true;
    settings.global.log_filter = "^loading";
  };

  programs.adb.enable = true;

  # Arduino Udev Rules
  services.udev.extraRules = ''
    ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="vendor_id", ATTRS{idProduct}=="product_id", MODE="0660", TAG+="uaccess"
  '';

  environment.systemPackages = with pkgs; [
    # Tools
    sublime3
    unstable.bruno
    ngrok
    lazygit
    act
    nmap
    compose2nix

    # Hardware Dev
    arduino-ide
    arduino-cli
    read-edid
    ddcutil
  ];
}
