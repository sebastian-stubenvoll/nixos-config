{ config, lib, pkgs, ... }:

{
  age.secrets.uhh-vpn.file = ./secrets/uhh-vpn.age;
  networking.openconnect.interfaces.uhh = {
    gateway = "vpn.rrz.uni-hamburg.de";
    protocol = "anyconnect";
    user = "baq3994";
    passwordFile = config.age.secrets.uhh-vpn.path;
    extraOptions = {
      useragent = "AnyConnect";
      non-inter = true;
    };
    autoStart = false;
  };
}


