{ config, pkgs, lib, ... }:

{
  # Core Hyprland settings: monitors, input, misc
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    # Monitor configuration
    monitor = [
      ",preferred,auto,auto"
      ",addreserved,5,15,15,15"
      "desc:Lenovo Group Limited LEN T32p-20 VNA8W4PX,preferred,auto,1.2"
    ];

    # Autostart
    exec-once = [
      "wlsunset"
      "hyprpaper"
      "waybar"
      "avizo-service"
    ];

    # Environment variables
    env = [
      "XCURSOR_THEME,Bibata-Modern-Ice"
      "XCURSOR_SIZE,24"
      "GDK_SCALE,2"
    ];

    # Input configuration
    input = {
      kb_layout = "se";
      kb_variant = "mac";
      follow_mouse = 1;
      sensitivity = 0;

      touchpad = {
        natural_scroll = false;
        clickfinger_behavior = true;
      };
    };

    gestures = {
      workspace_swipe_invert = false;
      workspace_swipe_distance = 700;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      enable_swallow = true;
      swallow_regex = "^(alacritty)$";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {};
  };
}
