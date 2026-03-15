{ config, lib, pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.extraOptions = ''
    min-free = ${toString (30 * 1024 * 1024 * 1024)}
    max-free = ${toString (60 * 1024 * 1024 * 1024)}
  '';
}
