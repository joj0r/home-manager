{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in
{
  imports =
    [
      # Neovim system wide config
      ./systemnvim.nix
      (import "${home-manager}/nixos")
    ];

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
    useXkbConfig = false; # use xkb.options in tty.
  };

  security.sudo.extraRules = [
  	{
		users = ["jonas"];
		commands = [
			{
			command = "/run/current-system/sw/bin/nixos-rebuild";
			options = [ "NOPASSWD" ];
			}
		];
	}
  ];

  users.groups = {
    nixos = { 
      gid = 1000; 
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "nixos" ]; 
  };

  users.users.root = {
    extraGroups = [ "nixos" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmake # For Telesope in Neovim
    wget
    kitty
    git

    # Passwordstore with git-integration
    gnupg
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    settings = {
      max-cache-ttl = 60480000;
      default-cache-ttl = 60480000;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  environment.variables = {
    MANPAGER = "nvim + Man!";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

