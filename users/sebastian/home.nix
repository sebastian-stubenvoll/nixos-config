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

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      bind u split-window -h   # horizontal split (side by side)
      bind i split-window -v   # vertical split (top/bottom)
    '';    
  };
}
