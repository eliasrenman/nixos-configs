{ config, pkgs, lib, ... }:

{
  # Hyprland window rules
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # Float dialogs and popups
      "float on, match:class ^(file_progress)$"
      "float on, match:class ^(confirm)$"
      "float on, match:class ^(dialog)$"
      "float on, match:class ^(download)$"
      "float on, match:class ^(notification)$"
      "float on, match:class ^(error)$"
      "float on, match:class ^(splash)$"
      "float on, match:class ^(confirmreset)$"
      "float on, match:title ^(Open File)$"
      "float on, match:title ^(branchdialog)$"
      "float on, match:class ^(Lxappearance)$"
      "float on, match:class ^(wofi)$"
      "dim_around on, match:class ^(wofi)$"
      "stay_focused on, match:class ^(wofi)$"
      "float on, match:class ^(viewnior)$"
      "float on, match:title ^(Media viewer)$"
      "float on, match:title ^(Volume Control)$"
      "float on, match:title ^(Picture-in-Picture)$"

      # Force tile
      "tile on, match:title ^(.*)(Godot)(.*)$"
      "tile on, match:title ^(.*)Aseprite(.*)$"

      # Wlogout
      "float on, match:class ^(wlogout)$"
      "no_anim on, match:class ^(wlogout)$"

      # Idle inhibit
      "idle_inhibit focus, match:class ^(mpv)$"
      "idle_inhibit fullscreen, match:class ^(zen)$"

      # Size/position
      "size 800 600, match:title ^(Volume Control)$"
      "move 39% 420, match:title ^(Volume Control)$"

      # Workspace assignments
      "workspace 1, match:class ^(alacritty)$"
      "workspace 2, match:class ^(zen)$"
      "workspace 3, match:class ^(discord)$"
      "workspace 3, match:title ^(Spotify)(.*)$"
      "workspace 3, match:class ^(Slack)$"
      "workspace special, match:class ^(thunar)$"
      "workspace special, match:class ^(YouTube Music)$"

      # Screen share (xwaylandvideobridge)
      "opacity 0.0 override, match:class ^(xwaylandvideobridge)$"
      "no_anim on, match:class ^(xwaylandvideobridge)$"
      "no_initial_focus on, match:class ^(xwaylandvideobridge)$"
      "max_size 1 1, match:class ^(xwaylandvideobridge)$"
      "no_blur on, match:class ^(xwaylandvideobridge)$"
      "opacity 1 override, match:class ^(dev.warp.Warp)$"
    ];
  };
}
