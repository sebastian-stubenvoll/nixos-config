{ config, lib, pkgs, inputs, ... }:

{
  services.printing.enable = true;  
  
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
