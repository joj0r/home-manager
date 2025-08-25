{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Common config
      ./config-cmn.nix
    ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pinentry-qt
    
  ];

  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-qt;
  };

  home-manager.users.jonas = import ./home-wsl.nix;

}
