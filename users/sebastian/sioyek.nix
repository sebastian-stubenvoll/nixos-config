{ config, pkgs, ... }:

{
  programs.sioyek = {
    enable = true;

    config = {
      startup_commands = [
        "toggle_custom_color"
      ];
      # background (#282c34)
      background_color = "0.156 0.172 0.204";

      # highlights (One Dark palette)
      highlight_color_a = "0.878 0.424 0.459"; # red
      highlight_color_b = "0.596 0.765 0.475"; # green
      highlight_color_c = "0.380 0.686 0.937"; # blue
      highlight_color_d = "0.776 0.471 0.867"; # purple
      highlight_color_e = "0.898 0.753 0.482"; # yellow
      highlight_color_f = "0.337 0.714 0.761"; # cyan

      link_highlight_color = "0.380 0.686 0.937";
      synctex_highlight_color = "0.776 0.471 0.867";
      search_highlight_color = "0.898 0.753 0.482";

      status_bar_color = "0.156 0.172 0.204";
      status_bar_text_color = "0.671 0.698 0.749";

      ui_background_color = "0.156 0.172 0.204";
      ui_text_color = "0.671 0.698 0.749";
    };
  };
}
