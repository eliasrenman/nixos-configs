# GUI applications - shared by laptop and mini-pc
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    chromium

    # Editors/IDEs
    vscode
    zed-editor
    (pkgs.writeShellScriptBin "zed" ''exec zeditor "$@"'')

    # File managers
    xfce.thunar
    xfce.thunar-archive-plugin
    xarchiver

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
    inav-configurator

    # Audio tools
    alsa-tools

    # Hardware control
    brightnessctl
    pamixer
  ];
}
