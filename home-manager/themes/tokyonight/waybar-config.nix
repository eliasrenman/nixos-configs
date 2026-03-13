{ config, pkgs, lib, ... }:

{
  # Waybar module layout and functionality
  # Styling is in waybar-style.nix
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin = "5";
        height = 34;

        modules-left = [
          "hyprland/workspaces"
          "custom/separator"
          "custom/weather"
          "custom/separator"
          "memory"
          "custom/separator"
          "cpu"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "backlight#value"
          "custom/separator"
          "pulseaudio"
          "pulseaudio#microphone"
          "custom/separator"
          "network"
          "battery"
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
          format = "{:%e %b %Y %H:%M}";
          tooltip-format = "{:%e %B %Y}";
        };

        cpu = {
          interval = 5;
          format = "  {usage}% ({load})";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "alacritty -e 'glances'";
        };

        memory = {
          interval = 5;
          format = "  {}%";
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
          format-disconnected = "⚠  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
          on-click = "alacritty -e 'nmtui'";
        };

        "network#vpn" = {
          interface = "tun0";
          format = " ";
          format-disconnected = "  Disconnected";
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
          persistent_workspaces = {
            "*" = 5;
          };
        };

        pulseaudio = {
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon}  {format_source}";
          format-muted = "󰸈";
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
          format-source = " {volume}%";
          format-source-muted = " ";
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
          format = "{icon} {percent}%";
          format-icons = [ " " ];
          on-scroll-down = "lightctl down";
          on-scroll-up = "lightctl up";
        };

        "custom/power" = {
          format = "⏻";
          on-click = "wlogout";
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
