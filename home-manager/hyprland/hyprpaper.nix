{ config, pkgs, lib, ... }:

let
  wallpaper = ../../assets/forest-view.jpg;
in
{
  # Hyprpaper wallpaper daemon configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor = HDMI-A-1
      path = ${wallpaper}
      fit_mode = cover
    }

    wallpaper {
      monitor =
      path = ${wallpaper}
      fit_mode = cover
    }
  '';

  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprpaper wallpaper daemon";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
