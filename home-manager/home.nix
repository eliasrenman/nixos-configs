{ config, pkgs, lib, ... }:

let
  hostname = lib.strings.removeSuffix "\n" (builtins.readFile /etc/hostname);
  isHyprland = hostname == "minipc";
in
{
  imports = [
    ./zsh.nix
  ] ++ lib.optionals isHyprland [
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
