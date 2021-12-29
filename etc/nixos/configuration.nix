# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
	myCustomLayout = pkgs.writeText "us-custom" ''
		xkb_symbols "us-custom" {
			include "us(basic)"
			include "level3(ralt_switch)"
			key <LatA> { [ a, A, at ] };
			key <LatE> { [ e, E, exclam ] };
		};
	'';
in

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	nixpkgs = {
		config = {
			allowUnfree = true;
			# License stuff
			joypixels.acceptLicense = true;
		};
	};

	# Auto garbage collector
	nix.gc.automatic = true;
	nix.gc.dates = "03:00";

	# Auto upgrade the system
	system.autoUpgrade.enable = true;
	system.autoUpgrade.allowReboot = true;
	system.autoUpgrade.dates = "04:00";

	environment = { 
		binsh = "${pkgs.dash}/bin/dash";
		shellAliases = {
			ls = "ls --color=auto -AhX --group-directories-first";
			la = "ls --color=auto -AhlX --group-directories-first";
			ip = "ip -c=auto";
			mv = "mv -iv";
			cp = "cp -riv";
			mkdir = "mkdir -vp";
			df = "df -h";
			tree = "tree -C";
		};
		variables = {
			EDITOR = "nvim"; 
			VISUAL = "nvim";
		};
	};

	# Use the systemd-boot EFI boot loader.
	# boot.loader.systemd-boot.enable = true;
	# boot.loader.grub.version = 2;
	boot = {
		kernelPackages = pkgs.linuxPackages_zen;
		loader = {
			efi.canTouchEfiVariables = true;
			grub = {
				enable = true;
				devices = [ "nodev" ];
				efiSupport = true;
				#useOSProber = true;
			};
		};
	};

	networking.hostName = "nixos"; # Define your hostname.
	#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	
	# Set your time zone.
	time.timeZone = "America/Caracas";
	
	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	# Per-interface useDHCP will be mandatory in the future, so this generated config
	# replicates the default behaviour.
	networking.useDHCP = false;
	networking.interfaces.enp3s0f2.useDHCP = true;
	networking.interfaces.wlp2s0.useDHCP = true;
	
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		useXkbConfig = true;
		font = "Lat2-Terminus16";
		#KeyMap = "us";
	};

	# Enable bspwm Desktop Environment.
	services.xserver = {
		# Enable the X11 windowing system.
		enable = true;
		# Configure keymap in X11
		extraLayouts.us-custom = {
			description = "My custom US layout";
			languages = [ "eng" ];
			symbolsFile = myCustomLayout;
		};
		layout = "us-custom";
		xkbOptions = "caps:swapescape, ctrl:swap_lalt_lctl";	
		displayManager = {
			startx.enable = true;
		};
	}; 


	fonts = {
		fonts = with pkgs; [
			# Chinese, Japanese, Korean fonts 
			noto-fonts-cjk
			# Emoji font
			joypixels
			# My favorite font
			(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
		];
	};

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
	hardware = {
		opengl = {
			enable = true;
			extraPackages = with pkgs; [
				intel-media-driver
				vaapiIntel
				vaapiVdpau
				libvdpau-va-gl
			];
		};
		pulseaudio = {
			enable = true;
			# Need by mpd to be able to use Pulseaudio
			extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
		};
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.extraUsers = {
		carlos = {
			shell = "/home/carlos/.nix-profile/bin/zsh";
			isNormalUser = true;
			extraGroups = [ "wheel" "audio" ];
		};
	};

	services.getty.autologinUser = "carlos";

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# Terminal Utilities
		wget
		vim
		htop
		unzip
		unrar
		tree
		file
		# Driver Testing Utilities
		intel-gpu-tools
		libva-utils
		vdpauinfo
	];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	##List services that you want to enable:
	
	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;
	
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
	system.stateVersion = "21.05"; # Did you read the comment?
}
