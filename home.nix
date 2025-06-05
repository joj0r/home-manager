{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jonas";
  home.homeDirectory = "/home/jonas";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];
         

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    tree
    nextcloud-client
    bitwarden-desktop
    ledger
    taskwarrior3
    nwg-drawer # App drawer

    # For clipboard support
    wl-clipboard

    hyprsunset # Blue light filter
    spotify # Needs unfree set

    # Installed for wimwiki
    python312Full 
    python312Packages.six
    cargo # Installed for rnix_lsp

    # Passwordstore with git-integration
    gnupg
    pinentry-tty
    pass
    pass-git-helper

    # To change GTK theme
    nwg-look

    libreoffice

    # For developing
    ripgrep # For telecope in nvim
    fd # For telecope in nvim
    lazygit
    starship

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

      # Ledger felles.ledger
      lfbal = "ledger -f felles.ledger bal assets liabilities";
      lfbud = "ledger -f felles.ledger budget -p \"this month\" exp";

      # Ledger regnskap.ledger
      lrbal = ''ledger -f regnskap.ledger bal \(assets liabilities klatrekort\) and not \(Pensjon or PetraAsk\) -V'';
      lrbud = "ledger -f regnskap.ledger budget -p \"this month\" exp";


      # Bluetooth connect SRS-XB3
      bs = "bluetoothctl connect FC:A8:9A:21:44:EF";

      # WH-1000XM4
      bw = "bluetoothctl connect F8:4E:17:45:41:43";
      
      # Geneva Touring s
      bt = "bluetoothctl connect 00:02:5B:00:B0:CC";
    };
    bashrcExtra = lib.fileContents ~/dotfiles/bash/bashrc-arch;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraLuaConfig = lib.fileContents /home/jonas/dotfiles/nvim/init.lua;
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
        helper = "${
          pkgs.pass-git-helper}/bin/pass-git-helper";
        useHttpPath = true;
      };
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
    ".config/pass-git-helper/git-pass-mapping.ini".text = ''
      [*github.com/joj0r/*]
      target=Coding/Github CLI
      
      [*github.com/sweco-nojojo/*]
      target=Jobb/Sweco/Github_CLI
      
      [*dev.azure.com*]
      target=Jobb/Sweco/Git credentials DocumentGenerator-NO
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell

  home.sessionVariables = {
    EDITOR = "nvim";

    # Hyprland envs
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 20;

    # For scaling of GDK apps
    GDK_SCALE = 2;
    # trying to set dark theeme (failed)
    GTK_THEME = "Adwaita-dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
