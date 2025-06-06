{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Neovim system wide config
      ./systemnvim.nix
      (import "${home-manager}/nixos")
    ];

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  fileSystems."/" =
    { device = "zpool/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zpool/nix";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "zpool/var";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F9ED-972A";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking.hostName = "xps13"; # Define your hostname.
  networking.hostId = "85867c89"; # For ZFS
  networking.networkmanager.enable = true; 

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
 
  # For adding neccessary lines to /etc/pam.d for auto open
  # kde wallet on login
  security.pam.services.greetd.kwallet = {
    enable = true;
    forceRun = true;
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

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

  home-manager.users.jonas = import ./home.nix;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmake # For Telesope in Neovim
    wget
    kitty
    git

    # For loging in
    cage
    greetd.regreet

    # Pkgs for Hyprland
    waybar
    xfce.thunar # File manager
    wofi # Ctrl - R

    # For audio control
    pamixer
    playerctl

    # For controlling brightness
    brightnessctl

    # Passwordstore with git-integration
    gnupg
    pinentry-tty
    pinentry-curses

    # For Nextcloud autologin and storing NC password
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
  ];

  # Greetd for loging in
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "cage -s -- regreet";
        user = "greeter";
      };
    };
  };
  # ReGreet as login manager. 
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    settings = {
      max-cache-ttl = 60480000;
      default-cache-ttl = 60480000;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

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

