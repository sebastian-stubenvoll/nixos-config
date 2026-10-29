{ config, pkgs, ... }:

{
  # App launcher (Ctrl+Space) and dmenu for scripts (clipboard, power menu).
  # Default look for now.
  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "kitty";
      font = "FiraCode Nerd Font Mono:size=11";
      icon-theme = config.gtk.iconTheme.name;
    };
  };
}
