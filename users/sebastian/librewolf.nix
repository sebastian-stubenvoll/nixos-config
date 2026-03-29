{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;

    settings = {
      "browser.toolbars.bookmarks.visibility" = "never";
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      
      # Keep sidebar open by default
      "sidebar.main.variableWidth" = true;
      "sidebar.position_start" = true;
      "sidebar.visible" = true;

      # Allow extensions to control the New Tab page
      "browser.newtab.extensionControlled" = true;
    };

    policies = {
      ExtensionSettings = {
        # SponsorBlock - Hidden from toolbar
        "sponsorBlocker@ajay.app" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          default_area = "menupanel";
        };
        # uBlock Origin - Hidden from toolbar (uBlock is built into LibreWolf/pre-installed)
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          default_area = "menupanel";
        };
        # Privacy Badger
        "privacybadger@eff.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger/latest.xpi";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        # Tabliss - New Tab Page
        "extension@tabliss.io" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
        };
        # Karakeep
        "addon@karakeep.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/karakeep/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        # Vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        # Zotero connector
        "zotero@chnm.gmu.edu" = {
          installation_mode = "force_installed";
          install_url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.199.xpi";
          default_area = "navbar";
        };
      };
    };
  };

  systemd.user.services.zotero-symlinks = {
    Unit = {
      Description = "Ensure Zotero PDF tool symlinks exist";
    };

    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "zotero-symlinks" ''
        set -euo pipefail

        profile=$(ls "$HOME/.mozilla/firefox" 2>/dev/null | grep '\.default' | head -n1 || true)

        if [ -z "$profile" ]; then
          echo "No Firefox/LibreWolf profile found"
          exit 0
        fi

        dir="$HOME/.mozilla/firefox/$profile/zotero"
        mkdir -p "$dir"

        ln -sf /run/current-system/sw/bin/pdftotext \
          "$dir/pdftotext-Linux-x86_64"

        ln -sf /run/current-system/sw/bin/pdfinfo \
          "$dir/pdfinfo-Linux-x86_64"

        echo "Zotero symlinks ensured for profile: $profile"
      '');
    };
  };

  systemd.user.timers.zotero-symlinks = {
    Unit = {
      Description = "Periodically ensure Zotero symlinks exist";
    };

    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "10m";
      Unit = "zotero-symlinks.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
