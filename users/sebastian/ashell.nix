{ config, pkgs, ... }:

{
  programs.ashell = {
    enable = true;
    # Started with graphical-session.target, so the bar runs in niri and Hyprland.
    systemd.enable = true;
    settings = {
      enable_esc_key = true;
      # ashell 0.10+ replaced `appearance.style` with `appearance.bar.*`.
      # "solid" draws one full-width background instead of per-module islands.
      appearance = {
        bar = {
          surface = "solid";
        };
      };
      modules = {
        left = [
          "Workspaces"
        ];
        center = [
          "WindowTitle"
        ];
        right = [
          "MediaPlayer"
          "SystemInfo"          
          [
            "Tempo"
            "Privacy"
            "Settings"
          ]
          "Tray"
        ];
      };
      workspaces = {
        indicator_format = "NameAndIcons";
      };
    };
  };
}
