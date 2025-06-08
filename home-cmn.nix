{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jonas";
  home.homeDirectory = "/home/jonas";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    tree # List dir as tree
    ledger
    taskwarrior3

    # For clipboard support
    wl-clipboard

    cargo # Installed for rnix_lsp

    # Passwordstore with git-integration
    pinentry-tty
    pass
    pass-git-helper

    # For developing
    ripgrep # For telecope in nvim
    fd # For telecope in nvim
    lazygit
    starship # command prompt
    jq # JSON utils

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

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -alF";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraPython3Packages = pyPkgs: with pyPkgs;
      [ six packaging tasklib ];
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };


  programs.git = {
    enable = true;
    userName = "Jonas Stene";
    userEmail = "jonas@stene.li";
    extraConfig = {
      init = {
	      defaultBranch = "main";
      };
      merge = { tool = "vimdiff"; };
      mergetool = { path = "nvim"; };
      credential = {
        helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
        useHttpPath = true;
      };
      safe.directory = "/etc/nixos/";
    };
  };



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

    ".taskrc".source = dotfiles/taskrc;

    ".config/pass-git-helper/git-pass-mapping.ini".source = dotfiles/git-pass-mapping.ini;

    # Kitty
    ".config/kitty/kitty.conf".source = dotfiles/kitty/kitty.conf;
    ".config/kitty/pass_keys.py".source = dotfiles/kitty/pass_keys.py;

    # Tmux
    ".tmux.conf".source = dotfiles/tmux.conf;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell

  home.sessionVariables = {

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
