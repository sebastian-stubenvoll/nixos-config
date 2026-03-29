{ config, pkgs, ... }:

let
  onedark = {
    bg        = "#282c34";
    fg        = "#abb2bf";
    black     = "#282c34";
    red       = "#e06c75";
    green     = "#98c379";
    yellow    = "#e5c07b";
    blue      = "#61afef";
    magenta   = "#c678dd";
    cyan      = "#56b6c2";
    white     = "#abb2bf";
    brightBlack   = "#5c6370";
    brightWhite   = "#ffffff";
  };
in

{
  home.packages = with pkgs; [
    tdf
  ];
  
  programs.zathura = {
    enable = true;

    options = {
      default-bg            = onedark.bg;
      default-fg            = onedark.fg;

      statusbar-bg          = onedark.bg;
      statusbar-fg          = onedark.fg;

      inputbar-bg           = onedark.bg;
      inputbar-fg           = onedark.fg;

      notification-bg       = onedark.bg;
      notification-fg       = onedark.fg;
      notification-error-bg = onedark.red;
      notification-error-fg = onedark.bg;
      notification-warning-bg = onedark.yellow;
      notification-warning-fg = onedark.bg;

      highlight-color       = onedark.yellow;
      highlight-active-color = onedark.blue;

      completion-bg         = onedark.bg;
      completion-fg         = onedark.fg;
      completion-highlight-bg = onedark.blue;
      completion-highlight-fg = onedark.bg;
      completion-group-bg   = onedark.bg;
      completion-group-fg   = onedark.magenta;

      recolor               = true;
      recolor-lightcolor    = onedark.bg;
      recolor-darkcolor     = onedark.fg;

      index-bg              = onedark.bg;
      index-fg              = onedark.fg;
      index-active-bg       = onedark.blue;
      index-active-fg       = onedark.bg;

      render-loading        = true;
      render-loading-bg     = onedark.bg;
      render-loading-fg     = onedark.blue;
    };
  };
}
