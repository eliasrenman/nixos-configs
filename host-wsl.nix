# WSL configuration (CLI only, minimal)

{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./packages-cli.nix
  ];

  # WSL-specific settings
  # Note: WSL handles most hardware, boot, and networking automatically

  # Networking (WSL manages this, but we can set hostname)
  networking.hostName = "nixos-wsl";

  # No X server needed
  # No display manager needed
  # No sound/pipewire needed
  # No bluetooth needed
  # No Nvidia drivers needed

  # Security
  security.polkit.enable = true;

  system.stateVersion = "24.05";
}
