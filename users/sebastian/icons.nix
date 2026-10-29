{ config, pkgs, ... }:

let
  # Monochrome line icons. Not in nixpkgs; the repo ships prebuilt theme folders.
  arcticons-dark = pkgs.stdenvNoCC.mkDerivation {
    pname = "arcticons-dark-icon-theme";
    version = "9.6.5.0";

    src = pkgs.fetchFromGitHub {
      owner = "Arcticons-Team";
      repo = "Arcticons-Linux";
      rev = "9.6.5.0";
      hash = "sha256-yr5yp9WMZ6VHWuJgX2oN4iXTtRgBINuGA11YB/N1/Ow=";
    };

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r arcticons-dark $out/share/icons/Arcticons-Dark
      # Upstream falls back to breeze-dark, which isn't installed here.
      substituteInPlace $out/share/icons/Arcticons-Dark/index.theme \
        --replace-fail "Inherits=breeze-dark,Adwaita,hicolor" "Inherits=Adwaita,hicolor"
    '';
  };
in
{
  # Sets gtk-icon-theme-name in gtk-3.0/gtk-4.0 settings.ini, which ashell,
  # fuzzel and GTK apps read. Icons Arcticons lacks fall back to Adwaita.
  gtk = {
    enable = true;
    iconTheme = {
      package = arcticons-dark;
      name = "Arcticons-Dark";
    };
  };
}
