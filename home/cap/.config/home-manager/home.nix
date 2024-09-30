{ config, pkgs, ... }:

{
  home.username = "cap";
  home.homeDirectory = "/home/cap";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs._1password
    pkgs._1password-gui
    pkgs.babashka
    pkgs.bash
    pkgs.bat
    pkgs.bottom
    pkgs.clang
    pkgs.curl
    pkgs.dejavu_fonts
    pkgs.difftastic
    pkgs.fzf
    pkgs.gh
    pkgs.gimp
    pkgs.glade
    pkgs.gnome-builder
    pkgs.go_1_22
    pkgs.gparted
    pkgs.inkscape
    pkgs.inotify-tools
    pkgs.kitty
    pkgs.mosquitto
    pkgs.nerdfonts
    pkgs.nodejs_22
    pkgs.nodenv
    pkgs.pkg-config
    pkgs.powerline-fonts
    pkgs.pyenv
    pkgs.python312
    pkgs.rbenv
    pkgs.ruby_3_2
    pkgs.slack
    pkgs.starship
    pkgs.tmux
    pkgs.transmission_4-gtk
    pkgs.tree
    pkgs.virtualenv
    pkgs.vscode
    pkgs.wget

    (pkgs.callPackage ./cursor.nix { })

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
    CFGDIR = "$HOME/.cfg/";
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  fonts.fontconfig.enable = true;

  # fonts.packages = with pkgs; [
  #   noto-fonts
  #   noto-fonts-cjk
  #   noto-fonts-emoji
  #   liberation_ttf
  #   fira-code
  #   fira-code-symbols
  #   mplus-outline-fonts.githubRelease
  #   dina-font
  #   proggyfonts
  # ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Geoff Johnson";
    userEmail = "geoff.jay@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      hm-update = "NIXPKGS_ALLOW_UNFREE=1 home-manager switch";
      g = "git";
      v = "vim";
      config = "/home/cap/.nix-profile/bin/git --git-dir=$CFGDIR --work-tree=$HOME";
      cfg = "config";

      # nix aliases for things I'll probably never remember without them
      nix-stray-roots = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory)\"";
      nix-gc = "nix-collect-garbage -d";
      nix-tidy = "nix-env --delete-generations old";
    };

    initExtra = ''
      source $HOME/.zshrc.extra
    '';

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.cursor = {
  #   enable = true;
  #   package = cursor;
  # };
}
