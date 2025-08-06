{ config, pkgs, ... }:

{
	imports = [ 
		# Include the results of the hardware scan.
		<nixos-hardware/lenovo/thinkpad/t480>
		./hardware-configuration.nix
		<home-manager/nixos>
		./nvim.nix
		./tmux.nix
	];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.i2c.enable = true;

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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
	services.printing.drivers = [ pkgs.epson-escpr ];

	# autodetect printers
	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};

	services.gvfs.enable = true;

	services.tailscale.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  home-manager.useUserPackages = true;
  home-manager.users.carlos = { pkgs, ... }: {
	  home.stateVersion = "25.05";
	  programs.kitty = {
		  enable = true;
		  themeFile = "gruvbox-dark-hard";
		  settings = {
			  font_family = "JetBrains Mono Nerd Font";
			  font_size = 10;
			  enable_audio_bell = false;
			  window_padding_width = "5 5 5 5";
			  background_opacity = "0.90";
			  confirm_os_window_close = 0;
			  hide_window_decorations = true;
		  };
	  };
		programs.neomutt = {
			enable = true;
		};
		programs.fzf = {
			enable = true;
			enableZshIntegration = true;
		};
	  programs.zsh = {
	  	enable = true;
			dotDir = ".config/zsh";
			defaultKeymap = "viins";
			setOptions = [
				"AUTO_CD"             # Go to folder path without using cd.
				"AUTO_PUSHD"          # Push the old directory onto the stack on cd.
				"PUSHD_IGNORE_DUPS"   # Do not store duplicates in the stack.
				"PUSHD_SILENT"        # Do not print the directory stack after pushd or popd.
				"CORRECT"             # Spelling correction
				"CDABLE_VARS"         # Change directory to a path stored in a variable.
				"EXTENDED_GLOB"       # Use extended globbing syntax.
			];
			history = {
				expireDuplicatesFirst = true;
				ignoreDups = true;
				ignoreSpace = true;
				save = 1000000;
				share = true;
			};
			plugins = [
				{
					name = "powerlevel10k";
					src = pkgs.zsh-powerlevel10k;
					file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
				}
			];
			initContent = ''
				path+=''$HOME/.local/share/scripts
				source ~/.config/zsh/.p10k.zsh
				alias d='dirs -v'
				for index ({0..9}) alias "''$index"="cd +''${index}"; unset index
			'';
			shellAliases = {
				".." = "cd ..";
				cp = "cp -riv";
				df = "df -h";
				mkdir = "mkdir -vp";
				mv = "mv -iv";
				ls = "ls --color=auto -GAhX --group-directories-first";
				la = "ls --color=auto -hX --group-directories-first";
				grep = "grep --color=auto";
				ip = "ip -c=auto";
				httpserver = "python -m http.server 8000";
				music = "ncmpcpp";
				duh = "du -h --max-depth=1 | sort -h -r";
				mail = "neomutt";
				dc = "docker compose";
			};
		};
		programs.git = {
			enable = true;
			userName = "Carlos Lobo";
			userEmail = "86011416+CarlosLoboxyz@users.noreply.github.com";
			extraConfig = {
				init.defaultBranch = "master";
			};
		};
		xdg.dataFile."scripts/odoo-scaffold" = {
			enable = true;
			executable = true;
			text = ''
				#!/bin/sh
				docker compose exec odoo odoo scaffold $1 /tmp
				docker compose cp odoo:/tmp/$1 $2
			'';
		};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carlos = {
    isNormalUser = true;
    description = "carlos";
    shell = "/etc/profiles/per-user/carlos/bin/zsh";
    extraGroups = [ "networkmanager" "wheel" "video" "i2c" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "carlos";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
		sessionVariables = {
			NIXOS_OZONE_WL = "1";
		};
  	variables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
		};
  };

	# OBS virtual camera
	boot.extraModulePackages = with config.boot.kernelPackages; [
		v4l2loopback
	];
	boot.extraModprobeConfig = ''
		options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Cam" exclusive_caps=1
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
		imagemagickBig
		tldr
		intel-media-sdk
		nmap
		obsidian
		neovim
		wl-clipboard
		htop
		ferdium
		ddcutil
		mangohud
		keepassxc
		moonlight-qt
		libreoffice-qt
		picard # musicbrainz (music-tag editor)
		unrar
		mpv
		supersonic # navidrone client
		read-edid
		# Gnome
		gnomeExtensions.advanced-alttab-window-switcher	
		gnomeExtensions.night-theme-switcher
		gnomeExtensions.appindicator
		gnomeExtensions.caffeine
		gnomeExtensions.tailscale-qs
		# gnomeExtensions.quick-settings-tweaker
		gnome-decoder
		gnome-pomodoro
		gnome-tweaks
		dconf
		dconf-editor
  ];

  environment.gnome.excludePackages = (with pkgs; [
  	gnome-music
		gnome-tour
		gnome-characters
		gnome-text-editor
		gnome-maps
		yelp
		geary
		gedit
		epiphany
	]);

  fonts.packages = with pkgs; [
  	nerd-fonts.jetbrains-mono
		noto-fonts
		noto-fonts-cjk-sans
  ];

  virtualisation.docker.rootless = {
		enable = true;
		setSocketVariable = true;
  };

	programs.virt-manager.enable = true;

	virtualisation.spiceUSBRedirection.enable = true;
	# services.spice-webdavd.enable = true;

	virtualisation.libvirtd = {
		enable = true;
		qemu = {
			package = pkgs.qemu_kvm;
			runAsRoot = true;
			swtpm.enable = true;
			ovmf = {
				enable = true;
				packages = [(pkgs.OVMF.override {
					secureBoot = true;
					tpmSupport = true;
				}).fd];
			};
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
