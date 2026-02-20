{ config, pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Remove GNOME bloat you probably don't want
  environment.gnome.excludePackages = with pkgs.gnome; [
    gnome-music
    gnome-weather
    gnome-maps
    epiphany   # GNOME browser, you already have Firefox
    totem      # video player, you have vlc
  ];

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome-extension-manager
  ];
}
