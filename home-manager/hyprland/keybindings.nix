{ config, pkgs, lib, ... }:

let
  keybinds = [
    { keys = "SUPER + T";                   desc = "Open terminal (Alacritty)"; }
    { keys = "SUPER + Q";                   desc = "Close active window"; }
    { keys = "SUPER + M";                   desc = "Exit Hyprland"; }
    { keys = "SUPER + F";                   desc = "File manager (Thunar)"; }
    { keys = "SUPER + V";                   desc = "Toggle floating mode"; }
    { keys = "SUPER + SPACE";               desc = "App launcher (Wofi)"; }
    { keys = "SUPER + P";                   desc = "Pseudo tiling"; }
    { keys = "SUPER + J";                   desc = "Toggle split orientation"; }
    { keys = "SUPER + L";                   desc = "Lock screen"; }
    { keys = "SUPER + H";                   desc = "Show keybindings cheatsheet"; }
    { keys = "SUPER + Arrow Keys";          desc = "Move focus between windows"; }
    { keys = "SUPER + 1-0";                 desc = "Switch to workspace 1-10"; }
    { keys = "SUPER + SHIFT + Left/Right";  desc = "Next/Previous workspace"; }
    { keys = "SUPER + SHIFT + 1-0";         desc = "Move window to workspace 1-10"; }
    { keys = "SUPER + Scroll";              desc = "Scroll through workspaces"; }
    { keys = "SUPER + TAB";                 desc = "Cycle group windows"; }
    { keys = "SUPER + CTRL + Arrow Keys";   desc = "Resize active window"; }
    { keys = "SUPER + Print";               desc = "Color picker (Hyprpicker)"; }
    { keys = "SUPER + LMB Drag";            desc = "Move window"; }
    { keys = "SUPER + RMB Drag";            desc = "Resize window"; }
  ];

  keybindList = lib.concatMapStringsSep "\n"
    (k: "${k.keys}  →  ${k.desc}")
    keybinds;

  hypr-keybinds = pkgs.writeShellScriptBin "hypr-keybinds" ''
    cat <<'BINDS' | wofi --dmenu --prompt "Keybindings" --insensitive --normal-window
${keybindList}
BINDS
  '';
in
{
  # Hyprland keybindings
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Application launchers
      "$mainMod, T, exec, alacritty"
      "$mainMod, Q, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, F, exec, thunar"
      "$mainMod, V, togglefloating,"
      "$mainMod, SPACE, exec, wofi --show drun --normal-window"
      "$mainMod, P, pseudo,"
      "$mainMod, J, togglesplit,"
      "$mainMod, L, exec, swaylock"

      # Focus movement
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Workspace switching
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod SHIFT, right, workspace, e+1"
      "$mainMod SHIFT, left, workspace, e-1"

      # Move window to workspace
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Mouse workspace scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Tab group
      "$mainMod, tab, changegroupactive"

      # Resize with keyboard
      "$mainMod CTRL, right, resizeactive, 25 0"
      "$mainMod CTRL, left, resizeactive, -25 0"
      "$mainMod CTRL, up, resizeactive, 0 -25"
      "$mainMod CTRL, down, resizeactive, 0 25"

      # Media keys
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # Hardware buttons
      ", XF86PowerOff, exec, wlogout"

      # Keybindings cheatsheet
      "$mainMod, H, exec, ${hypr-keybinds}/bin/hypr-keybinds"

      # Screenshot
      ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy -t image/png"
      "$mainMod, Print, exec, hyprpicker -a"

      # Brightness
      ", XF86MonBrightnessDown, exec, lightctl down"
      ", XF86MonBrightnessUp, exec, lightctl up"
    ];

    # Repeat binds (hold key)
    binde = [
      ", XF86AudioRaiseVolume, exec, volumectl -u up"
      ", XF86AudioLowerVolume, exec, volumectl -u down"
      ", XF86AudioMute, exec, volumectl toggle-mute"
    ];

    # Mouse binds
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Lid switch binds
    bindl = [
      ", switch:on:Lid Switch, exec, swaylock"
      ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 3000x2000@60,0x0,auto\""
      ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
    ];
  };
}
