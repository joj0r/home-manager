{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./home-cmn.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nextcloud-client
    bitwarden-desktop

    hyprsunset # Blue light filter
    spotify # Needs unfree set

    # To change GTK theme
    nwg-look

    libreoffice

    ungoogled-chromium

  ];

  programs.bash = {
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
    bashrcExtra = lib.fileContents /home/jonas/dotfiles/bash/bashrc-arch;
  };

  programs.neovim = {
    extraLuaConfig = lib.fileContents dotfiles/nvim/init-xps.lua;
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    # Waybar
    ".config/waybar/config.jsonc".source = dotfiles/waybar/config.jsonc;
    ".config/waybar/style.css".source = dotfiles/waybar/style.css;
    ".config/waybar/power_menu.xml".source = dotfiles/waybar/power_menu.xml;
    ".config/waybar/mediaplayer.py".source = dotfiles/waybar/mediaplayer.py;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell

  home.sessionVariables = {

    # Hyprland envs
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 20;

    # For scaling of GDK apps
    GDK_SCALE = 2;
    # trying to set dark theeme (failed)
    GTK_THEME = "Adwaita-dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
