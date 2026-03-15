{ config, pkgs, ... }:

{
  programs.kitty= {
    enable = true;
    themeFile = "OneDark";
    font.package = pkgs.nerd-fonts.fira-code;
    font.name = "FiraCode Nerd Font Mono";
    font.size = 10;    
  };
}
