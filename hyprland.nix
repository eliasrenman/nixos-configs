{ config, pkgs, lib, ... }:

{
  # Symlink home-manager config directory for standalone usage
  system.activationScripts.homeManagerConfig = lib.stringAfter [ "users" ] ''
    rm -rf /home/elias/.config/home-manager
    ln -sf /home/elias/nixos-configs/home-manager /home/elias/.config/home-manager
    chown -h elias:users /home/elias/.config/home-manager
  '';

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
    # Home manager (standalone)
    home-manager

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
