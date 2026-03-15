{ config, pkgs, ... }:

{
  programs.ashell = {
    enable = true;
    settings = {
      enable_esc_key = true;
      appearance = {
        style = "Solid";
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
            "Clock"
            "Privacy"
            "Settings"
          ]
          "Tray"
        ];
      };
    };
  };
}
