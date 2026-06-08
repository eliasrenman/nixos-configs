{ config, pkgs, lib, ... }:

{
  # Waybar Tokyo Night styling
  programs.waybar.style = ''
    /* Tokyo Night color definitions */
    @define-color magenta #9d7cd8;
    @define-color magenta_2 #ff007c;
    @define-color bg_highlight #292e42;
    @define-color blue_1 #65bcff;
    @define-color bg #222436;

    /* Animations */
    @keyframes blink-warning {
        70% {
            color: white;
        }
        to {
            color: white;
            background-color: orange;
        }
    }

    @keyframes blink-critical {
        70% {
          color: white;
        }
        to {
            color: white;
            background-color: red;
        }
    }

    /* Reset all styles */
    * {
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0px;
        padding: 0;
    }

    /* The whole bar */
    window#waybar {
        background-color: @bg;
        border-radius: 20px;
        font-family: JetBrainsMono Nerd Font;
        font-size: 14px;
        min-width: 54px;
    }

    /* All modules */
    #battery,
    #clock,
    #backlight,
    #cpu,
    #custom-keyboard-layout,
    #memory,
    #mode,
    #custom-weather,
    #network,
    #pulseaudio,
    #temperature,
    #tray,
    #idle_inhibitor,
    #window,
    #workspaces,
    #custom-power,
    #custom-media,
    #custom-PBPbattery {
        padding: 0.5rem 0;
        color: @blue_1;
        min-width: 54px;
    }

    #custom-separator {
        color: @bg_highlight;
        padding: 0.1rem 0;
        min-width: 54px;
    }

    .modules-left,
    .modules-center,
    .modules-right {
        background-color: transparent;
    }

    /* Clock */
    #clock {
        color: @magenta;
    }

    #custom-weather {
        color: @magenta;
    }

    /* Battery */
    #battery {
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #battery.warning {
        color: orange;
    }

    #battery.critical {
        color: red;
    }

    #battery.warning.discharging {
        animation-name: blink-warning;
        animation-duration: 3s;
    }

    #battery.critical.discharging {
        animation-name: blink-critical;
        animation-duration: 2s;
    }

    /* CPU */
    #cpu {
        color: @magenta;
    }

    #cpu.warning {
        color: orange;
    }

    #cpu.critical {
        color: red;
    }

    /* Memory */
    #memory {
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        color: @magenta;
    }

    #memory.warning {
        color: orange;
    }

    #memory.critical {
        color: red;
        animation-name: blink-critical;
        animation-duration: 2s;
        padding-left: 5px;
        padding-right: 5px;
    }

    /* Mode */
    #mode {
        border-bottom: 3px transparent;
        color: @magenta_2;
        padding: 7px;
    }

    /* Network */
    #network.disconnected {
        color: orange;
    }

    /* Pulseaudio */
    #pulseaudio {
        color: @magenta;
        border-left: 0px;
        border-right: 0px;
        margin-left: 0;
        margin-right: 0;
        border-radius: 0;
    }

    #pulseaudio.microphone {
        border-left: 0px;
        border-right: 0px;
        margin-left: 0;
        padding-top: 0;
        border-radius: 0;
    }

    /* Temperature */
    #temperature.critical {
        color: red;
    }

    /* Window */
    #window {
        font-weight: bold;
        color: #f7768e;
    }

    /* Custom media */
    #custom-media {
        color: @magenta;
    }

    /* Workspaces */
    #workspaces {
        font-size: 16px;
        border-radius: 20px;
        padding: 0.35rem 0;
        min-width: 54px;
    }

    #workspaces button {
        margin: 0;
        color: @blue_1;
        padding: 0.25rem 0 0.15rem;
        min-width: 54px;
    }

    #workspaces button label {
        border-bottom: 2px solid transparent;
        padding: 0 0.35rem 0.1rem;
        min-width: 1.35rem;
    }

    #workspaces button.active {
        color: @magenta;
    }

    #workspaces button.active label {
        border-bottom-color: @magenta;
    }

    #workspaces button.urgent {
        color: #c9545d;
    }

    #workspaces button.urgent label {
        border-bottom-color: @magenta_2;
    }

    /* Power button */
    #custom-power {
        font-size: 18px;
        padding: 0.5rem 0 1rem;
    }

    /* Backlight */
    #backlight.icon {
        padding-right: 1px;
        font-size: 13px;
    }
  '';
}
