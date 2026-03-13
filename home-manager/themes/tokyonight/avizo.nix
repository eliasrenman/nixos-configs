{ config, pkgs, lib, ... }:

{
  # Avizo (volume/brightness OSD) Tokyo Night styling
  xdg.configFile."avizo/config.ini".text = ''
    [default]
    # The time to show the notification for.
    time = 1.0

    # The width of the notification.
    width = 210

    # The height of the notification.
    height = 200

    # The border radius of the notification in px.
    border-radius = 6

    # The spacing between blocks in the progress indicator.
    block-spacing = 0

    # Tokyo Night colors
    # Background: fg_dark with transparency
    background = rgba(169,177,214,0.8)

    # Bar color: magenta
    bar-fg-color = #9D7CD8
  '';
}
