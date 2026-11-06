{ config, lib, pkgs, ... }:

{
  # Per-interface DNS: the hotspot's DNS stays on wlan0 and Tailscale only
  # answers tailnet names. Without this, MagicDNS owns /etc/resolv.conf and
  # captive portals can't resolve or redirect.
  services.resolved.enable = true;
  # avahi (printers.nix) already handles mDNS
  services.resolved.settings.Resolve.MulticastDNS = false;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    dns = "systemd-resolved";

    # Internal USB Ethernet to the T2 chip (same MAC on every T2 Mac). Not a
    # real network; otherwise NM retries DHCP on it forever and shows it
    # as "connecting".
    unmanaged = [ "mac:ac:de:48:00:11:22" ];

    # Lets NM notice login pages (connectivity state "portal")
    settings.connectivity = {
      uri = "http://nmcheck.gnome.org/check_network_status.txt";
      response = "NetworkManager is online";
      interval = 60;
    };
  };

  # Throwaway Chromium that uses the hotspot's DHCP DNS directly,
  # for portals that still misbehave
  programs.captive-browser = {
    enable = true;
    interface = "wlan0";
  };
}
