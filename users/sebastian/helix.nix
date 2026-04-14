{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    tinymist 
    typstyle
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      editor = {
        line-number = "relative";
        mouse = false;
        bufferline = "always";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        statusline = {
          left = [ "mode" "file-name" "file-modification-indicator" "version-control" ];
          center = [ ];
          right = [ "spinner" "diagnostics" "register" "read-only-indicator" "file-type" "position" "position-percentage" ];
          separator = "│";
          mode = {
            normal = "normal";
            insert = "insert";
            select = "select";
          };
        };

        gutters = {
          layout = [ "diff" "diagnostics" "line-numbers" "spacer" ];
        };

        inline-diagnostics = {
          cursor-line = "hint";
        };

        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
        };
      };

      keys.normal = {
        C-g = [ ":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ];
        S-h = "goto_prev_diag";
        S-l = "goto_next_diag";

        # Sub-mappings for C-h and C-l
        C-h = {
          d = "goto_prev_diag";
          D = "goto_first_diag";
          f = "goto_prev_function";
          t = "goto_prev_class";
          a = "goto_prev_parameter";
          c = "goto_prev_comment";
          T = "goto_prev_test";
          p = "goto_prev_paragraph";
          g = "goto_prev_change";
          space = "add_newline_above";
        };
        C-l = {
          d = "goto_next_diag";
          D = "goto_last_diag";
          f = "goto_next_function";
          t = "goto_next_class";
          a = "goto_next_parameter";
          c = "goto_next_comment";
          T = "goto_next_test";
          p = "goto_next_paragraph";
          g = "goto_next_change";
          space = "add_newline_below";
        };
      };
    };

    languages = {
      language-server.tinymist = {
        command = "tinymist";
        config = {
          semanticTokens = "full";
        };
      };

      language = [
        {
          name = "typst";
          auto-format = true;
          formatter = { command = "typstyle"; args = ["-l" "100" ]; };
          language-servers = [ "tinymist" ];
        }
      ];
    };
  };
}
