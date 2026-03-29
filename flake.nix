{
  description = "Dynamic NixOS Flake with User Home Manager Modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs25.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      rev = "31f46de4ef6675a2a1eface29f7c4c9952f2498c";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      hostConfig = {
        calculator = [ "sebastian" ];
      };

      getNixFiles = dir:
        if lib.pathExists dir then
          let
            content = builtins.readDir dir;
            files = lib.filterAttrs (name: type: 
              (type == "regular" || type == "symlink") && lib.hasSuffix ".nix" name
            ) content;
          in
          map (name: dir + "/${name}") (builtins.attrNames files)
        else
          [ ];

    in {
      nixosConfigurations = lib.mapAttrs (hostname: users:
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          
          modules = [
            { imports = getNixFiles ./common/nixos; }
            { imports = getNixFiles (./hosts + "/${hostname}"); }

            # Home Manager Setup
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = getNixFiles ./common/home;

              home-manager.users = lib.genAttrs users (username: 
                let 
                  userPath = ./users + "/${username}";
                in
                {
                  imports = getNixFiles userPath;
                }
              );
            }

            { networking.hostName = hostname; }
          ];
        }
      ) hostConfig;
    };
}
