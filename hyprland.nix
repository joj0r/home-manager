{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Built in display
      monitor = [
        "eDP-1, preferred,auto, 1.6"
      # Epson Projector
        "desc:Seiko Epson Corporation EPSON PJ 0x01010101, preffered, 0x-1080, 1.5"
      ];

      ###################
      ### MY PROGRAMS ###
      ###################

      # Set programs that you use
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun";
      "$mod" = "SUPER";

      #################
      ### AUTOSTART ###
      #################

      "exec-once" = [
        "waybar &"
        "/usr/lib/pam_kwallet_init &"
        "nextcloud &"
        "gammastep-indicator &"
      ];

      "exec" = [
        "nwg-drawer -r"
      ];

      #####################
      ### LOOK AND FEEL ###
      #####################
      
      # Refer to https://wiki.hyprland.org/Configuring/Variables/
      
      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = { 
          gaps_in = 2;
          gaps_out = 2;
      
          border_size = 2;
      
          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
      
          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;
      
          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
      
          layout = "dwindle";
      };
      
      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
          rounding = 5;
      
          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 0.9;
      
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
      
          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
              enabled = true;
              size = 3;
              passes = 1;
              
              vibrancy = 0.1696;
          };
      };
      
      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
          enabled = true;
      
          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };
      
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
      };
      
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
          new_status = "master";
      };
      
      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = { 
          force_default_wallpaper = 2; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };
      
      # unscale Xwayland
      xwayland = {
          force_zero_scaling = true;
      };

      #############
      ### INPUT ###
      #############
      
      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
          kb_layout = "no";
          kb_options = "caps:super";

          follow_mouse = 1;
      
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      
          touchpad = {
              natural_scroll = false;
          };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
          workspace_swipe = true;
      };
      
      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
          name = "mx-master-mouse";
          sensitivity = -0.5;
      };

      ####################
      ### KEYBINDINGSS ###
      ####################
      
      # See https://wiki.hyprland.org/Configuring/Keywords/
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

      bind =
        [
          # Volume and Media Control
          ", XF86AudioMute, exec, pamixer -t"
          
          "SHIFT, XF86AudioRaiseVolume, exec, pamixer -i 1"
          "SHIFT, XF86AudioLowerVolume, exec, pamixer -d 1"
          
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl prev"
          
          # Backlight
          ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

          # Lock
          "$mainMod, Escape, exec, hyprlock"
          
          # Screenshot
          ", Print, exec, grim"
          "Ctrl, Print, exec, slurp | grim -g -"

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mainMod, Return, exec, $terminal"
          "$mainMod, W, killactive,"
          "$mainMod, Q, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, T, togglesplit," # dwindle
          "$mainMod, F, fullscreen, 1"
          "$mainMod, XF86AudioPlay, exec, spotify-launcher"
          
          # Move focus with mainMod + h,j,k,l keys
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"
          
          # Move windows
          "$mainMod + shift, h, movewindow, l"
          "$mainMod + shift, l, movewindow, r"
          "$mainMod + shift, j, movewindow, d"
          "$mainMod + shift, k, movewindow, u"

          # Resize split
          "$mainMod + CTRL, h, splitratio, -0.1"
          "$mainMod + CTRL, l, splitratio, 0.1"

          # Scroll through existing workspaces with mainMod + arrowkeys
          "$mainMod, right, workspace, e+1"
          "$mainMod, left, workspace, e-1"

        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                "$mainMod CTRL, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
              ]
            )
            9)
        );

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################
      
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      windowrule = [
        "float, nextcloud"
        "move 100%-w-10 3%, nextcloud"
      
      # Do not have to filter on title, the rules do not apply to tiled windows
        "center, blender"
        "size 50% 50%, blender"
      ];
      
      # Thunderbird notification
      windowrulev2 = [
        "float, class:(thunderbird), title:(^$)"
        "move 100%-w-10 80%, class:(thunderbird), title:(^$)"
      
      # Firefox notifications including bitwarden unlock window
        "float, class:(firefox), title:(^$)"
        "float, class:(firefox), title:(.*)(Bitwarden)(.*)"
      
      # Download spotify needs other rounding
        "rounding 19, class:(zenity)"
        "suppressevent maximize, class:.*" # You'll probably like this.
      ];

      # Hyprgrass plugin settings
      plugin = {
        touch_gestures = {
          hyprgrass-bind = [
            # swipe left from right edge
            ", edge:r:l, workspace, +1"

            # swipe up from bottom edge
            ", edge:d:u, exec, wvkbd-mobintl"

            # nwg-drawer (app-drawer)
            ", edge:t:d, exec, nwg-drawer"
            ", edge:l:r, exec, nwg-drawer"

            # swipe down with 4 fingers
            ", swipe:4:d, killactive"

            # Hyprspace show and hide
            ", swipe:3:d, overview:open"
            ", swipe:3:u, overview:close"
          ];
        };
      };
    };

    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
      pkgs.hyprlandPlugins.hyprspace
    ];
  };
}
