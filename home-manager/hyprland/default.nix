{ config, pkgs, lib, ... }:

{
  imports = [
    ./settings.nix
    ./keybindings.nix
    ./window-rules.nix
    ./wofi.nix
    ./hyprpaper.nix
    ./remote-desktop.nix
  ];

  wayland.windowManager.hyprland.enable = true;
}
