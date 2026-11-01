{ config, pkgs, ... }:

{
  # Sets gtk-icon-theme-name in gtk-3.0/gtk-4.0 settings.ini, which is where
  # ashell (and GTK apps) look up the icon theme. Dark variant for dark backgrounds.
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };
}
