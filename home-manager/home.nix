{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland
    ./themes/tokyonight
  ];

  home.username = "elias";
  home.homeDirectory = "/home/elias";
  home.stateVersion = "24.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Allow unfree packages (for standalone mode)
  nixpkgs.config.allowUnfree = true;
}
