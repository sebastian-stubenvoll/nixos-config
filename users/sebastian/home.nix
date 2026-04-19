{ config, pkgs, ... }:

{
  home.username = "sebastian";
  home.homeDirectory = "/home/sebastian";

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  programs.bash.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fastfetch
    corefonts
    
    signal-desktop
    thunderbird
    firefox

    steam
    discord
    mumble
    
    shotwell
    rapidraw
    rawtherapee
    winboat

    typst
    zotero
  ];

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      bind i split-window -h   # horizontal split (side by side)
      bind u split-window -v   # vertical split (top/bottom)

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set-option -g escape-time 0
    '';    
  };
}
