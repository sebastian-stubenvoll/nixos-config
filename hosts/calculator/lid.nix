{ config, lib, pkgs, ... }:

{
  services.upower.enable = true;
  
  services.logind.settings.Login = {
    handleLidSwitch = "hibernate";          # normal laptop behavior
    handleLidSwitchExternalPower = "hibernate";
    handleLidSwitchDocked = "ignore";     # ignore lid when docked
    handlePowerKey = "hibernate";
  };

  services.udev.extraRules = ''
  # Create a symlink so hyprdynamicmonitors finds the power line
  SUBSYSTEM=="power_supply", KERNEL=="ADP1", SYMLINK+="line_power_ACAD"
 '';
 }
