{
  description = "Dynamic NixOS Flake with User Home Manager Modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs25.url = "github:nixos/nixpkgs/nixos-26.05";
    claude-code.url = "github:sadjow/claude-code-nix";
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };

    nixpkgs-kernel.url = "github:nixos/nixpkgs/2fcb964de67fcf60b43471c55d5d99e61a9ccb5a";
    nixos-hardware-kernel = {
      url = "github:NixOS/nixos-hardware/3e7edd9afe17e45521300e041c65de3015f4a302";
      flake = false;
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, agenix, claude-code, ... }@inputs:
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
            agenix.nixosModules.default
            { nixpkgs.overlays = [ claude-code.overlays.default ]; }

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
