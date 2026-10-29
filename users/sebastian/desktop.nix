{ config, pkgs, lib, ... }:

# Session tools shared by niri and the fallback Hyprland session.
# Everything here uses standard Wayland protocols and starts with
# graphical-session.target, so it works under both compositors.

let
  home = config.home.homeDirectory;
  wallpaper = "${home}/wallpaper.jpg";
  screenshotDir = "${home}/Screenshots";

  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    choice=$(printf '%s\n' Lock Logout Hibernate Reboot Shutdown \
      | ${lib.getExe pkgs.fuzzel} --dmenu --prompt "power> ")
    case "$choice" in
      Lock)      loginctl lock-session ;;
      Logout)    loginctl terminate-session "$XDG_SESSION_ID" ;;
      Hibernate) systemctl hibernate ;;
      Reboot)    systemctl reboot ;;
      Shutdown)  systemctl poweroff ;;
    esac
  '';

  # Region screenshot opened in satty for annotating, then saved or copied.
  annotate = pkgs.writeShellScriptBin "screenshot-annotate" ''
    region=$(${lib.getExe pkgs.slurp}) || exit 0
    ${lib.getExe pkgs.grim} -g "$region" - | ${lib.getExe pkgs.satty} --filename -
  '';
in
{
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    playerctl
    jq
    powermenu
    annotate
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 20;
  };

  # Wallpaper
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Lock screen (PAM entry lives in hosts/calculator/configuration.nix)
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      image = wallpaper;
      effect-blur = "8x2";
      clock = true;
      timestr = "%H:%M";
      datestr = "%a, %d %b";
      font = "FiraCode Nerd Font Mono";
      indicator = true;
      indicator-radius = 120;
      indicator-thickness = 6;
      ignore-empty-password = true;
      show-failed-attempts = true;
      inside-color = "1e1e1ecc";
      ring-color = "505050ff";
      key-hl-color = "c8c8c8ff";
      line-color = "00000000";
      separator-color = "00000000";
      text-color = "c8c8c8ff";
    };
  };

  # Idle: lock after 5 minutes and before hibernate
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.systemd}/bin/loginctl lock-session"; }
    ];
    events = {
      lock = "${lib.getExe config.programs.swaylock.package} -f";
      before-sleep = "${pkgs.systemd}/bin/loginctl lock-session";
    };
  };

  # Monitor profiles, carried over from hyprdynamicmonitors
  services.kanshi = {
    enable = true;
    settings =
      let
        laptop = "eDP-1";
        acer = "Acer Technologies K272HL T67EE0048521";
        lg = "LG Electronics 24GM77 411KCAS07592";
      in
      [
        {
          profile.name = "outside";
          profile.outputs = [
            { criteria = laptop; status = "enable"; mode = "2880x1800"; scale = 1.5; }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            { criteria = laptop; status = "disable"; }
            { criteria = acer; mode = "1920x1080@60Hz"; position = "0,0"; scale = 1.0; }
            { criteria = lg; mode = "1920x1080@144.001Hz"; position = "1920,0"; scale = 1.0; }
          ];
        }
        {
          profile.name = "home-small";
          profile.outputs = [
            { criteria = laptop; status = "disable"; }
            { criteria = lg; mode = "1920x1080@60Hz"; position = "0,0"; scale = 1.0; }
          ];
        }
        {
          # Lid closed: laptop panel not reported at all
          profile.name = "home2";
          profile.outputs = [
            { criteria = acer; mode = "1920x1080@60Hz"; position = "0,0"; scale = 1.0; }
            { criteria = lg; mode = "1920x1080@144.001Hz"; position = "1920,0"; scale = 1.0; }
          ];
        }
      ];
  };

  # Volume/brightness popups (driven by swayosd-client in the keybinds)
  services.swayosd.enable = true;

  # Clipboard history (picker bound to Mod+V)
  services.cliphist.enable = true;

  # Screenshot annotation
  programs.satty = {
    enable = true;
    settings.general = {
      early-exit = true;
      copy-command = "wl-copy";
      output-filename = "${screenshotDir}/satty-%Y-%m-%d_%H-%M-%S.png";
    };
  };
}
