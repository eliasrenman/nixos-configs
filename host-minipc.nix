# Mini PC configuration (Hyprland desktop)
# Hardware: Ryzen-based system with integrated graphics

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware/minipc.nix
    ./common.nix
    ./packages-cli.nix
    ./packages-gui.nix
    ./modules/zen-browser.nix
    ./hyprland.nix
    ./regreet.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # Early KMS: load AMD GPU driver in initrd for Plymouth and boot splash
  boot.initrd.kernelModules = [ "amdgpu" ];

  # fsck will fail under vbox and cause a boot to hang, so turn it off
  boot.initrd.checkJournalingFS = false;

  # Networking
  networking.hostName = "minipc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Printing
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  # X server and input
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.xserver.xkb.layout = "se";

  # Security
  security.polkit.enable = true;

  # MPD
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
  };

  # Fonts
  fonts.fontDir.enable = true;

  # Graphics (integrated AMD)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Wayland session variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    BROWSER = "zen";
  };

  # Set Zen Browser as default
  xdg.mime.defaultApplications = {
    "text/html" = "zen.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
  };

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "elias" ];

  # Mini PC specific packages
  environment.systemPackages = with pkgs; [
    anytype
    aseprite
    godot_4
    pkgs."godot_4-export-templates-bin"
    blender
  ];

  system.activationScripts.godotExportTemplates.text = ''
    template_source="${pkgs."godot_4-export-templates-bin"}/share/godot/export_templates/4.6.3.stable"
    template_target="/home/elias/.local/share/godot/export_templates/4.6.3.stable"

    install -d -o elias -g users /home/elias/.local/share/godot/export_templates
    if [ -e "$template_target" ] && [ ! -L "$template_target" ]; then
      mv "$template_target" "$template_target.backup"
    fi
    ln -sfn "$template_source" "$template_target"
    chown -h elias:users "$template_target"
  '';

  system.stateVersion = "24.05";
}
