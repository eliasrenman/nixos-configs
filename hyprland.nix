{ config, pkgs, lib, ... }:
{
  # Enable the Hyprland Desktop Environment.
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Fonts (Nerd Fonts for waybar icons)
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  # Swaylock PAM support
  security.pam.services.swaylock = {};

  # Waybar with experimental features (needed for Hyprland workspaces)
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    # Hyprland ecosystem
    hyprland
    hyprpaper
    hyprpicker
    wlogout
    wofi
    waybar
    wlsunset
    slurp
    grim
    wl-clipboard
    swaylock-effects

    # Polkit authentication agent
    kdePackages.polkit-kde-agent-1

    # Ricing tools & themes
    cava
    nwg-look
    tokyonight-gtk-theme
    material-icons

    # Ricing deps
    glib
    polkit
    xorg.xmodmap
    xorg.xset
    xorg.xsetroot

    # Plymouth boot theme (ricing)
    plymouth
  ];

  # Plymouth ricing theme
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [ "quiet" ];
  boot.plymouth.extraConfig = ''
    DeviceScale=1
  '';
  boot.plymouth.themePackages = with pkgs; [
    (adi1090x-plymouth-themes.override { selected_themes = [ "colorful_loop" ]; })
  ];
  boot.plymouth.theme = "colorful_loop";
}
