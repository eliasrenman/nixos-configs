{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland-theme.nix
    ./waybar-config.nix
    ./waybar-style.nix
    ./bat.nix
    ./alacritty.nix
    ./wofi-style.nix
    ./avizo.nix
    ./wlogout.nix
  ];
}
