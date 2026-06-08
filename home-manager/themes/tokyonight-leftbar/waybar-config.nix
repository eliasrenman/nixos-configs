{ config, pkgs, lib, ... }:

{
  # Waybar module layout and functionality
  # Styling is in waybar-style.nix
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "left";
        margin = "5";
        width = 54;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "pulseaudio"
          "pulseaudio#microphone"
          "custom/separator"
          "network"
          "custom/separator"
          "custom/power"
        ];

        "idle_inhibitor" = {
          format = "{icon} ";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
        };

        clock = {
          interval = 10;
          format = "{:%H:%M\n%e %b}";
          tooltip-format = "{:%e %B %Y}";
          justify = "center";
        };

        cpu = {
          interval = 5;
          format = "\n{usage}%";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "alacritty -e 'glances'";
        };

        memory = {
          interval = 5;
          format = "\n{}%";
          on-click = "alacritty -e 'glances'";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        network = {
          interval = 5;
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "⚠";
          tooltip-format = "{ifname}: {ipaddr}";
          justify = "center";
          on-click = "alacritty -e 'nmtui'";
        };

        "network#vpn" = {
          interface = "tun0";
          format = " ";
          format-disconnected = "Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        "hyprland/mode" = {
          format = "{}";
          tooltip = false;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 120;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "Ⅰ";
            "2" = "Ⅱ";
            "3" = "Ⅲ";
            "4" = "Ⅳ";
            "5" = "Ⅴ";
            "6" = "Ⅵ";
            "7" = "Ⅶ";
            "8" = "Ⅷ";
            "9" = "Ⅸ";
            "10" = "Ⅹ";
          };
          all-outputs = true;
          sort-by = "number";
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{icon}\n{volume}%";
          format-bluetooth = "{icon}\n{volume}%\n";
          format-bluetooth-muted = "\n";
          format-muted = "󰸈";
          justify = "center";
          format-icons = {
            headphone = "󰋋";
            hands-free = "וֹ";
            headset = " 󰥰 ";
            phone = "";
            portable = "";
            car = "";
            default = [ "" ];
          };
          on-click = "volumectl toggle-mute";
          on-click-right = "pavucontrol";
          on-scroll-up = "volumectl -u up";
          on-scroll-down = "volumectl -u down";
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "\n{volume}%";
          format-source-muted = "";
          justify = "center";
          on-click = "volumectl -m toggle-mute";
          on-click-right = "pavucontrol";
          on-scroll-up = "volumectl -m up";
          on-scroll-down = "volumectl -m down";
          scroll-step = 5;
        };

        "custom/weather" = {
          exec = "sh ~/.config/waybar/scripts/weather.sh 'Göteborg'";
          return-type = "json";
          interval = 600;
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        "backlight#icon" = {
          format = "{icon}";
          on-scroll-down = "lightctl down";
          on-scroll-up = "lightctl up";
        };

        "backlight#value" = {
          format = "{icon}\n{percent}%";
          format-icons = [ "" ];
          on-scroll-down = "lightctl down";
          on-scroll-up = "lightctl up";
        };

        "custom/power" = {
          format = "⏻";
          justify = "center";
          on-click = "wlogout-wrapper";
          tooltip = false;
        };

        "custom/separator" = {
          format = "•";
          interval = "once";
          tooltip = false;
        };
      };
    };
  };

  # Waybar scripts
  home.file.".config/waybar/scripts/weather.sh" = {
    source = ../../scripts/weather.sh;
    executable = true;
  };
}
