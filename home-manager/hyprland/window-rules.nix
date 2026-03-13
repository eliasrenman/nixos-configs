{ config, pkgs, lib, ... }:

{
  # Hyprland window rules
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Float dialogs and popups
      "float, class:^(file_progress)$"
      "float, class:^(confirm)$"
      "float, class:^(dialog)$"
      "float, class:^(download)$"
      "float, class:^(notification)$"
      "float, class:^(error)$"
      "float, class:^(splash)$"
      "float, class:^(confirmreset)$"
      "float, title:^(Open File)$"
      "float, title:^(branchdialog)$"
      "float, class:^(Lxappearance)$"
      "float, class:^(wofi)$"
      "float, class:^(viewnior)$"
      "float, title:^(Media viewer)$"
      "float, title:^(Volume Control)$"
      "float, title:^(Picture-in-Picture)$"

      # Force tile
      "tile, title:^(.*)(Godot)(.*)$"
      "tile, title:^(.*)Aseprite(.*)$"

      # Wlogout
      "fullscreen, class:^(wlogout)$"
      "float, title:^(wlogout)$"
      "fullscreen, title:^(wlogout)$"

      # Idle inhibit
      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      # Size/position
      "size 800 600, title:^(Volume Control)$"
      "move 39% 420, title:^(Volume Control)$"

      # Workspace assignments
      "workspace 1, class:^(alacritty)$"
      "workspace 2, class:^(firefox)$"
      "workspace 3, class:^(discord)$"
      "workspace 3, title:^(Spotify)(.*)$"
      "workspace 3, class:^(Slack)$"
      "workspace special, class:^(thunar)$"
      "workspace special, class:^(YouTube Music)$"

      # Screen share (xwaylandvideobridge)
      "opacity 0.0 override, class:^(xwaylandvideobridge)$"
      "noanim, class:^(xwaylandvideobridge)$"
      "noinitialfocus, class:^(xwaylandvideobridge)$"
      "maxsize 1 1, class:^(xwaylandvideobridge)$"
      "noblur, class:^(xwaylandvideobridge)$"
      "opacity 1 override, class:^(dev.warp.Warp)$"
    ];
  };
}
