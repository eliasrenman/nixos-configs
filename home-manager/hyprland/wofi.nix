{ config, pkgs, lib, ... }:

{
  # Wofi launcher configuration (layout, not styling)
  xdg.configFile."wofi/config".text = ''
    show=drun
    width=600
    height=300
    always_parse_args=true
    show_all=false
    print_command=true
    layer=overlay
    insensitive=true
    prompt=
  '';
}
