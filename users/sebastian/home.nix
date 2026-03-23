{ config, pkgs, ... }:

{
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    fastfetch
    
    signal-desktop
    thunderbird

    steam
    discord
    mumble
    
    rapidraw

    typst
  ];
}
