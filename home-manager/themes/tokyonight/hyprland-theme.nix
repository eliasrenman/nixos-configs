{ config, pkgs, lib, ... }:

let
  colors = import ./colors.nix;
in
{
  # Hyprland visual theming (colors, gaps, borders, animations, blur)
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 10;
      gaps_out = 0;
      border_size = 2;
      "col.inactive_border" = "rgba(f7768eff) rgba(bb9af7ff) 45deg";
      "col.active_border" = "rgba(bb9af7ff) rgba(f7768eff) 45deg";
      no_border_on_floating = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 3;
      active_opacity = 0.98;
      inactive_opacity = 0.65;

      blur = {
        enabled = true;
        size = 2;
        passes = 2;
      };

      shadow = {
        enabled = true;
        ignore_window = true;
        offset = "2 2";
        range = 8;
        render_power = 10;
        color = "rgba(00000055)";
      };
    };

    animations = {
      enabled = true;

      bezier = [
        "overshot, 0.05, 0.5, 0.1, 1.05"
        "smoothOut, 0.36, 0, 0.66, -0.56"
        "smoothIn, 0.25, 0.8, 0.5, 0.5"
      ];

      animation = [
        "windows, 1, 5, overshot, slide"
        "windowsOut, 1, 4, smoothOut, slide"
        "windowsMove, 1, 4, default"
        "border, 1, 10, default"
        "fade, 1, 2, smoothIn"
        "fadeDim, 1, 2, smoothIn"
        "workspaces, 1, 6, default"
      ];
    };

    layerrule = [
      "blur, gtk-layer-shell"
      "blur, lockscreen"
    ];

    windowrulev2 = [
      "opacity 1.0 1.0 override, class:^(zen)$, title:^(Picture-in-Picture)$"
    ];
  };
}
