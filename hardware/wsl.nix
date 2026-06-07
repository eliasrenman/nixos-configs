# WSL hardware configuration
# Minimal - WSL handles hardware automatically
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
