{ config, lib, pkgs, inputs, ... }:

{
   imports = [
     ./hardware-configuration.nix
     inputs.nixos-hardware.nixosModules.apple-t2
   ];
  

   hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = /. + "etc/nixos/firmware/brcm";
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];

  age.identityPaths= [
    "/root/.ssh/id_ed25519"
  ];
  
  networking.firewall.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  hardware.graphics = {
    enable = true;            # Enable graphics support
    enable32Bit = true;       # Enable 32-bit libraries for Steam
  };

  # Enable the AMDGPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Build the T2 kernel from the pinned revs in flake.nix instead of current nixpkgs
  boot.kernelPackages = lib.mkForce (
    let kpkgs = inputs.nixpkgs-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in kpkgs.linuxPackagesFor (
      kpkgs.callPackage "${inputs.nixos-hardware-kernel}/apple/t2/pkgs/linux-t2" { }
    )
  );

  # zotero still bundles Firefox ESR 140 (EOL 2026-10-13); drop once nixpkgs bumps it
  nixpkgs.config.permittedInsecurePackages = [
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];


  systemd.targets.suspend.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  systemd.targets.sleep.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };


  services.xserver.xkb = {
    layout = "de";
    variant = "mac";
    options = "caps:escape";
  };

  users.users.sebastian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "storage" "docker" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    helix
    kitty
    tmux
    mesa
    vulkan-tools
    htop
    geteduroam
    geteduroam-cli
    docker
    docker-compose
    brightnessctl
    xmage
    xwayland-satellite # niri starts it on demand for X11 apps (Steam, games, ...)
  ];

  virtualisation.docker.enable = true; 

  services.displayManager.ly = {
    enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;
  # swaylock needs a PAM entry to check the password
  security.pam.services.swaylock = { };

  # Polkit password dialog for both sessions
  security.soteria.enable = true;

  home-manager.backupFileExtension = ".hbakcup";
  

  # this is actually terrible
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}

