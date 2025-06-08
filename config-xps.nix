{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Neovim system wide config
      ./config-cmn.nix
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

  # For adding neccessary lines to /etc/pam.d for auto open
  # kde wallet on login
  security.pam.services.greetd.kwallet = {
    enable = true;
    forceRun = true;
  };
  security.pam.services.hyprlock = {};
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  home-manager.users.jonas = import ./home-xps.nix;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
}
