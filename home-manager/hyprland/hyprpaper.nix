{ config, pkgs, lib, ... }:

{
  # Hyprpaper wallpaper daemon configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wallpapers/forest-view.jpg

    wallpaper = eDP-1,~/.config/wallpapers/forest-view.jpg
    wallpaper = ,~/.config/wallpapers/forest-view.jpg
  '';
}
