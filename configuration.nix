# Main NixOS configuration
# This file imports the laptop configuration by default.
# For other machines, symlink the appropriate host-*.nix file.

{ config, pkgs, ... }:

{
  imports = [
    ./host-laptop.nix
  ];
}
