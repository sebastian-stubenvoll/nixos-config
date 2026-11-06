{ config, lib, pkgs, ... }:

let
  nmcli = "${pkgs.networkmanager}/bin/nmcli";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  # Pops a notification when NetworkManager detects a login page.
  # Clicking it opens captive-browser (installed by hosts/calculator/wifi.nix).
  portal-notify = pkgs.writeShellScript "captive-portal-notify" ''
    set -u
    ${nmcli} monitor | while read -r line; do
      case "$line" in
        *"Connectivity is now 'portal'"*)
          ssid=$(${nmcli} -t -g GENERAL.CONNECTION device show wlan0 2>/dev/null)
          (
            action=$(${notify-send} --app-name=Wi-Fi --urgency=critical \
              --icon=network-wireless \
              --action=default="Open login page" \
              "Hotspot login required" "''${ssid:-Wi-Fi} wants you to log in. Click to open.")
            if [ "$action" = default ]; then
              exec /run/current-system/sw/bin/captive-browser
            fi
          ) &
          ;;
      esac
    done
  '';
in
{
  systemd.user.services.captive-portal-notify = {
    Unit = {
      Description = "Notify when a Wi-Fi network needs a captive portal login";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${portal-notify}";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
