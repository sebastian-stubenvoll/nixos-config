{ config, lib, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftmeta = "leftcontrol";
            fn = "leftmeta";
          };
        };
      };
    };
  };
}
