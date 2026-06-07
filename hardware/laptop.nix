# Laptop hardware configuration
# TODO: Copy from /etc/nixos/hardware-configuration.nix on the laptop and replace this file
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = { device = "/dev/disk/by-uuid/PLACEHOLDER"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/PLACEHOLDER"; fsType = "vfat"; options = [ "fmask=0077" "dmask=0077" ]; };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
