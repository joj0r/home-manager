{ config, lib, pkgs, ... }:
{

  services = {

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.forge # Tiling WM
    gnomeExtensions.appindicator # App tray
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # Set dark theme for QT applications as well
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true; # prevents overriding
      settings = {
        "org/gnome/desktop/interface" = {
          accent-color = "blue";
          color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "caps:super" ];
        };

        # Keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" 
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" 
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" 
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" 
          ];
        };

        # "org/gnome/desktop/wm/keybindings/close" = {binding = "<Super>w";};

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "kitty";
          name = "Kitty terminal";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>z";
          command = "gnome-system-monitor";
          name = "System Monitor";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Super>e";
          command = "thunar";
          name = "Thunar file manager";
        };

      };
    }
  ];

}

