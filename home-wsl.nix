{ config, pkgs, lib, ... }:

{
  imports = [
    ./home-cmn.nix
  ];


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden-desktop


  ];

  programs.git = {
    enable = true;
    userName = "Jonas Stene";
    userEmail = "jonas.stene@sweco.no";
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


  programs.bash = {
    bashrcExtra = lib.fileContents ./dotfiles/bash/bashrc-wsl;
  };

  programs.neovim = {
    extraLuaConfig = lib.fileContents dotfiles/nvim/init-wsl.lua;
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {


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
