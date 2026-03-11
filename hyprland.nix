{ config, pkgs, ... }:

{
  # Enable the Hyprland Desktop Environment.
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # SDDM with Hyprland/ricing theme
  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
  };

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

    # SDDM theme
    sddm-chili-theme
    kdePackages.sddm
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
