{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      font = "FiraCode Nerd Font Mono 10";
      background-color = "#1e1e1eee";
      text-color = "#d0d0d0";
      border-color = "#505050";
      border-size = 1;
      border-radius = 0;
      padding = "10";
      default-timeout = 5000;
      icon-path = "${config.gtk.iconTheme.package}/share/icons/${config.gtk.iconTheme.name}";

      "urgency=high" = {
        border-color = "#d0d0d0";
        default-timeout = 0;
      };

      # Toggled with Mod+Shift+N (makoctl mode -t do-not-disturb)
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}
