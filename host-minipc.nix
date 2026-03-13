# Mini PC configuration (Hyprland desktop)
# Hardware: Ryzen-based system with integrated graphics

{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./common.nix
    ./packages-cli.nix
    ./packages-gui.nix
    ./hyprland.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # Early KMS: load AMD GPU driver in initrd for Plymouth and boot splash
  boot.initrd.kernelModules = [ "amdgpu" ];

  # fsck will fail under vbox and cause a boot to hang, so turn it off
  boot.initrd.checkJournalingFS = false;

  # Networking
  networking.hostName = "minipc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

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

  # Security
  security.polkit.enable = true;

  # MPD
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
  };

  # Fonts
  fonts.fontDir.enable = true;

  # Graphics (integrated AMD)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Wayland session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "elias" ];

  # Mini PC specific packages
  environment.systemPackages = with pkgs; [
    aseprite
    godot_4
    blender
  ];

  system.stateVersion = "24.05";
}
