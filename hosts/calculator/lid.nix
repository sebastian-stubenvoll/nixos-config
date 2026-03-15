{ config, lib, pkgs, ... }:

{
  services.upower.enable = true;
  
  services.logind.settings.Login = {
    handleLidSwitch = "suspend";          # normal laptop behavior
    handleLidSwitchExternalPower = "suspend";
    handleLidSwitchDocked = "ignore";     # ignore lid when docked
  };

  services.udev.extraRules = ''
  # Create a symlink so hyprdynamicmonitors finds the power line
  SUBSYSTEM=="power_supply", KERNEL=="ADP1", SYMLINK+="line_power_ACAD"
# '';
 }
