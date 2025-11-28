{ config, pkgs, ... }:

let
  dotfiles = ./configFiles;
  myPackPath = pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs;
in

{
  home.stateVersion = "25.05";

  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
  };
  xdg.configFile."tmux" = {
    source = "${dotfiles}/tmux";
    recursive = true;
  };

  programs.vifm = {
    enable = true;
  };
  xdg.configFile."vifm" = {
    source = "${dotfiles}/vifm";
    recursive = true;
  };

  programs.keepassxc = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark-hard";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 8;
      enable_audio_bell = false;
      window_padding_width = "5 5 5 5";
      background_opacity = "0.90";
      confirm_os_window_close = 0;
      hide_window_decorations = true;
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      rounded_corners = true;
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
    history = {
      path = "${config.xdg.configHome}/zsh/.zsh_history";
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
      source ''$HOME/.config/zsh/.p10k.zsh
      alias d='dirs -v'
      for index ({0..9}) alias "''$index"="cd +''${index}"; unset index
      eval "$(direnv hook zsh)"

      setopt AUTO_PUSHD # Push the old directory onto the stack on cd.
      setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
      setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.
      setopt CORRECT # Spelling correction
      setopt CDABLE_VARS # Change directory to a path stored in a variable.
      setopt EXTENDED_GLOB # Use extended globbing syntax.
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
      ar = "arduino-cli";
      arup = "arduino-cli upload";
      arbuild = "arduino-cli compile";
      arview = "arduino-cli monitor";
    };
  };

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Carlos Lobo";
    userEmail = "86011416+CarlosLoboxyz@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
  };
  programs.lazygit = {
    enable = true;
  };

  # Custom Scripts that live inside .local/share/scripts
  xdg.dataFile = {
    "scripts/odoo-scaffold" = {
      executable = true;
      source = "${dotfiles}/scripts/odoo-scaffold";
    };
    "scripts/generateNixEnv" = {
      executable = true;
      source = "${dotfiles}/scripts/generateNixEnv";
    };
  };

  # NEOVIM CONFIGURATIONS AND PLUGINS
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      undotree
      lazy-nvim
      snacks-nvim
      gruvbox-nvim
      conform-nvim
      dropbar-nvim
      gitsigns-nvim
      telescope-nvim
      mini-pairs
      mini-snippets
      trouble-nvim
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      # Tree:
      neo-tree-nvim
      nvim-web-devicons
      plenary-nvim
      nui-nvim
      # LSP:
      nvim-lspconfig
      # TreeSitter:
      nvim-treesitter.withAllGrammars
    ];
    # Language Servers, Linters and Formatters
    extraPackages = with pkgs; [
      nix
      gcc
      vscode-langservers-extracted
      stylua
      black
      prettierd
      gopls
      golines
      gotools
      gosimports
      golangci-lint
      python313Packages.jedi-language-server
      typescript-language-server
    ];
  };
  xdg.configFile = {
    "nvim/init.lua".source = pkgs.replaceVars "${dotfiles}/nvim/init.lua" {
      packPath = myPackPath;
    };
    "nvim/lua/config/keybindings.lua".source = "${dotfiles}/nvim/keybindings.lua";
    "nvim/snippets" = {
      source = "${dotfiles}/nvim/snippets";
      recursive = true;
    };
    "nvim/lua/plugins" = {
      source = "${dotfiles}/nvim/plugins";
      recursive = true;
    };
  };
}
