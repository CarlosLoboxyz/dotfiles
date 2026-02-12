{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    ardour
    gimp3
    imagemagickBig
    v4l-utils
  ];
}
