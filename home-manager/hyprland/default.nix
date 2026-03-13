{ config, pkgs, lib, ... }:

{
  imports = [
    ./settings.nix
    ./keybindings.nix
    ./window-rules.nix
    ./wofi.nix
    ./hyprpaper.nix
  ];

  wayland.windowManager.hyprland.enable = true;
}
