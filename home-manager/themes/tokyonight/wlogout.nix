{ config, pkgs, lib, ... }:

let
  colors = import ./colors.nix;
  wlogoutPkg = pkgs.wlogout;

  maxWidth = 900;
  maxHeight = 600;

  wlogout-wrapper = pkgs.writeShellScriptBin "wlogout-wrapper" ''
    # Get focused monitor resolution
    read width height < <(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | "\(.width) \(.height)"')

    margin_lr=$(( (width - ${toString maxWidth}) / 2 ))
    margin_tb=$(( (height - ${toString maxHeight}) / 2 ))

    # Clamp to minimum of 50
    [ "$margin_lr" -lt 50 ] && margin_lr=50
    [ "$margin_tb" -lt 50 ] && margin_tb=50

    exec wlogout -b 3 -n -L "$margin_lr" -R "$margin_lr" -T "$margin_tb" -B "$margin_tb"
  '';
in
{
  home.packages = [ wlogout-wrapper ];

  # wlogout Tokyo Night styling
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
    style = ''
      /* Tokyo Night wlogout theme */
      * {
          box-shadow: none;
          font-family: "JetBrains Mono Nerd Font";
      }

      window {
          background-color: rgba(26, 27, 38, 0.9);
      }

      button {
          color: ${colors.fg};
          background-color: ${colors.bg};
          border: 2px solid ${colors.bg_highlight};
          border-radius: 12px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          margin: 8px;
      }

      button:focus, button:active, button:hover {
          background-color: ${colors.bg_highlight};
          border-color: ${colors.magenta};
          outline-style: none;
      }

      #lock {
          color: ${colors.blue};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/lock.png"));
      }
      #lock:hover {
          color: ${colors.blue_light};
      }

      #logout {
          color: ${colors.red};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/logout.png"));
      }
      #logout:hover {
          color: ${colors.red_bright};
      }

      #suspend {
          color: ${colors.yellow};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/suspend.png"));
      }

      #shutdown {
          color: ${colors.red};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/shutdown.png"));
      }
      #shutdown:hover {
          color: ${colors.red_bright};
      }

      #reboot {
          color: ${colors.green};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/reboot.png"));
      }
      #reboot:hover {
          color: ${colors.green_light};
      }

      #hibernate {
          color: ${colors.cyan};
          background-image: image(url("${wlogoutPkg}/share/wlogout/icons/hibernate.png"));
      }
      #hibernate:hover {
          color: ${colors.cyan};
      }
    '';
  };
}
