{ config, pkgs, lib, ... }:

{
  imports = [
    ../tokyonight/hyprland-theme.nix
    ./waybar-config.nix
    ./waybar-style.nix
    ../tokyonight/bat.nix
    ../tokyonight/alacritty.nix
    ../tokyonight/wofi-style.nix
    ../tokyonight/avizo.nix
    ../tokyonight/wlogout.nix
    ../tokyonight/cursor.nix
  ];
}
