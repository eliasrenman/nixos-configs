# GUI applications - shared by laptop and mini-pc
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    vivaldi
    chromium

    # Editors/IDEs
    vscode
    zed-editor

    # File managers
    xfce.thunar
    xfce.thunar-archive-plugin

    # Media
    vlc
    pavucontrol
    playerctl

    # Applications
    discord
    spotify
    alacritty
    warp-terminal
    bruno

    # Audio tools
    alsa-tools

    # Hardware control
    brightnessctl
    pamixer
  ];
}
