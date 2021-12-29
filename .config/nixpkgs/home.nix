{ config, pkgs, ... }:

{
	imports = [ 
		./console.nix
		./text-editor.nix
		./graphical.nix
		./music.nix 
	];

	home.packages = with pkgs; [
		nix-prefetch-scripts
	];

	home.keyboard = null;
	home.username = "carlos";
	home.homeDirectory = "/home/carlos";
	home.stateVersion = "22.05";

	xdg = {
		userDirs = {
			desktop = "$HOME";
		};
	};

	programs = {
		home-manager.enable = true;
		home-manager.path = "$HOME/Downloads/home-manager";
	};
}
