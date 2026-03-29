{ config, pkgs, ... }:

{
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  programs.bash.enable = true;

  home.packages = with pkgs; [
    fastfetch
    
    signal-desktop
    thunderbird

    steam
    discord
    mumble
    
    rapidraw

    typst
    zotero
  ];

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      bind i split-window -h   # horizontal split (side by side)
      bind u split-window -v   # vertical split (top/bottom)
    '';    
  };
}
