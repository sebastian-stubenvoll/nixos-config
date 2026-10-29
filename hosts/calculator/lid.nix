{ config, lib, pkgs, ... }:

{
  services.upower.enable = true;
  
  services.logind.settings.Login = {
    handleLidSwitch = "hibernate";          # normal laptop behavior
    handleLidSwitchExternalPower = "hibernate";
    handleLidSwitchDocked = "ignore";     # ignore lid when docked
    handlePowerKey = "hibernate";
  };
}
