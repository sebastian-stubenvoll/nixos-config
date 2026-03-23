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
          default_area = "menupanel"; # Moves icon to the 'puzzle' menu/tray
        };
        # uBlock Origin - Hidden from toolbar (uBlock is built into LibreWolf/pre-installed)
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          default_area = "menupanel";
        };
        # Privacy Badger
        "jid1-Mnnjssqs6w9chw@jetpack" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger/latest.xpi";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        # Tabliss - New Tab Page
        "{7d27e738-2067-4ca2-9ad3-ca3fdc81acfd}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
        };
        # Karakeep
        "karakeep@karakeep.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/karakeep/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar"; # This "pins" it to the main toolbar
        };
      };
    };
  };
}
