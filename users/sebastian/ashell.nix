{ config, pkgs, ... }:

{
  programs.ashell = {
    enable = true;
    # nixpkgs' Rust hook now sets AWS_LC_SYS_USE_SYSTEM=1, but the ashell package
    # doesn't provide aws-lc. Remove once fixed upstream.
    package = pkgs.ashell.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.aws-lc ];
    });
    # Started with graphical-session.target, so the bar runs in niri and Hyprland.
    systemd.enable = true;
    settings = {
      enable_esc_key = true;
      # ashell 0.10+ replaced `appearance.style` with `appearance.bar.*`.
      # "solid" draws one full-width background instead of per-module islands.
      appearance = {
        bar = {
          surface = "solid";
        };
      };
      modules = {
        left = [
          "Workspaces"
        ];
        center = [
          "WindowTitle"
        ];
        right = [
          "MediaPlayer"
          "SystemInfo"          
          [
            "Tempo"
            "Privacy"
            "Settings"
          ]
          "Tray"
        ];
      };
      # workspaces = {
      #   indicator_format = "NameAndIcons";
      # };
    };
  };
}
