{ config, pkgs, ... }:

let
  # One Dark, same palette as kitty / zathura / sioyek
  onedark = {
    bg = "#282c34";
    fg = "#abb2bf";
    gray = "#5c6370";
    blue = "#61afef";
    yellow = "#e5c07b";
    white = "#ffffff";
  };
in
{
  # Launcher (Ctrl+Space) and dmenu for scripts (clipboard picker, power menu).
  programs.tofi = {
    enable = true;
    settings = {
      font = "FiraCode Nerd Font Mono";
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;

      background-color = "${onedark.bg}E6";
      text-color = onedark.fg;
      prompt-color = onedark.blue;
      placeholder-color = onedark.gray;
      input-color = onedark.white;
      default-result-color = onedark.fg;
      selection-color = onedark.blue;
      selection-match-color = onedark.yellow;
    };
  };
}
