# Laptop configuration (GNOME desktop)
# Hardware: Huawei MateBook with Nvidia GPU

{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/huawei/machc-wa>
    /etc/nixos/hardware-configuration.nix
    ./common.nix
    ./packages-cli.nix
    ./packages-gui.nix
    ./gnome.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "matebook";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # Spotify ports for Chromecasts and mobile phones
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Printing
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # X server and input
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.variant = "mac";

  # Security
  security.polkit.enable = true;

  # MPD
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
  };

  # Fonts
  fonts.fontDir.enable = true;

  # Location (for redshift/wlsunset)
  location.latitude = 63.825848;
  location.longitude = -20.263035;

  # Wayland session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  # Nvidia driver configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # FPV related
    betaflight-configurator

    # TTS for RotorHazard
    espeak-ng
    speechd
  ];

  system.stateVersion = "18.09";
}
