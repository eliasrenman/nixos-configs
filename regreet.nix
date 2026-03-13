{ config, pkgs, lib, ... }:

let
  colors = import ./home-manager/themes/tokyonight/colors.nix;
in
{
  # greetd + regreet (GTK4 greeter with Tokyo Night theme)
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = /home/elias/.config/wallpapers/forest-view.jpg;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 14;
    };
    extraCss = ''
      window {
        background-color: ${colors.bg_dark};
      }
    '';
  };
}
