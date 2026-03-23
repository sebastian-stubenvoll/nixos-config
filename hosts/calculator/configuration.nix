{ config, lib, pkgs, ... }:

let
  nixosHardware = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
    rev = "3966ce987e1a9a164205ac8259a5fe8a64528f72";
  };
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      "${nixosHardware}/apple/t2"
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
    extraGroups = [ "wheel" "storage" ]; # Enable ‘sudo’ for the user.
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
  ];

  programs.regreet = {
    enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # this is actually terrible
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}

