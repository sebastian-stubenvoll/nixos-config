{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hyprdynamicmonitors.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    hyprdynamicmonitors
    hyprtoolkit
  ];

  home.hyprdynamicmonitors = {
    enable = true;
    installExamples = false;
  };

  services.hyprpolkitagent.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "/home/sebastian/wallpaper.jpg";
          fit_mode = "fill";
        }
      ];
      splash = false;
    };
  };

  
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 20;
  };

  programs.hyprshot = {
    enable = true;
    saveLocation = "${config.home.homeDirectory}/Screenshots";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      "$extraMod" = "Fn";
      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,20"
      ];

      # Clamshell
      bindl = [
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 2880x1800, 0x0, 2\""
      ];

      bind = [
        # Move focus
        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"

        # Move windows
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, l, movewindow, r"

        # Change workspace
        "SUPER, f1, workspace, 1"
        "SUPER, f2, workspace, 2"
        "SUPER, f3, workspace, 3"
        "SUPER, f4, workspace, 4"
        "SUPER, f5, workspace, 5"
        "SUPER, f6, workspace, 6"
        "SUPER, f7, workspace, 7"
        "SUPER, f8, workspace, 8"
        "SUPER, f9, workspace, 9"

        "SUPER SHIFT, f1, movetoworkspace, 1"
        "SUPER SHIFT, f2, movetoworkspace, 2"
        "SUPER SHIFT, f3, movetoworkspace, 3"
        "SUPER SHIFT, f4, movetoworkspace, 4"
        "SUPER SHIFT, f5, movetoworkspace, 5"
        "SUPER SHIFT, f6, movetoworkspace, 6"
        "SUPER SHIFT, f7, movetoworkspace, 7"
        "SUPER SHIFT, f8, movetoworkspace, 8"
        "SUPER SHIFT, f9, movetoworkspace, 9"

        # Change workspace
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"

        # Move active window to a monitor in the specified direction
        "SUPER, I, movewindow, l"
        "SUPER, O, movewindow, r"

        # Move the current workspace to a monitor in the specified direction
        "SUPER SHIFT, I, movecurrentworkspacetomonitor, l"
        "SUPER SHIFT, O, movecurrentworkspacetomonitor, r"

        # Resizing
        "SUPER, R, submap, resize"

        # Disable
        "SUPER SHIFT, D, submap, disable"

        # Floating toggle
        "SUPER, F, togglefloating, active"
        "SUPER SHIFT, F, setfloating, active"
        "SUPER SHIFT, F, pin, active"

        # Fullscreen
        "SUPER SHIFT, M, fullscreen, 0 toggle"
        
        # Launch things
        "SUPER, T, exec, kitty"
        "CONTROL, space, exec, tofi-drun --drun-launch=true"
        "SUPER, X, killactive,"
        "SUPER SHIFT, X, forcekillactive,"

        # Screenshot
        "SUPER, S, exec, hyprshot -m region --clipboard-only"
        "SUPER SHIFT, S, exec, hyprshot -m region -o '${builtins.toString config.programs.hyprshot.saveLocation}'"
        "SUPER CONTROL SHIFT, S, exec, hyprshot -m monitor"
      ];

      windowrule = [
        "match:content 3, fullscreen on"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "mac";
        kb_options = "caps:escape,lv3:lalt_switch,compose:menu";
        repeat_delay = 250;
        follow_mouse = 2;
        touchpad = {
          tap-to-click = false;
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };
      exec-once = [
        "ashell"
        "hyprctl setcursor Adwaita 20"
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
    submaps."resize".settings = {
      bind = [
        ", escape, submap, reset"  
      ];
      binde = [
        ", h, resizeactive, -10 0"
        ", j, resizeactive, 0 10"
        ", k, resizeactive, 0 -10"
        ", l, resizeactive, 10 0"
      ];
    };
    submaps."disable".settings = {
      bind = [
        "SUPER SHIFT, D, submap, reset"  
      ];
    };
    extraConfig = ''
      source = $HOME/.config/hypr/monitors.conf
    '';
  };
}
