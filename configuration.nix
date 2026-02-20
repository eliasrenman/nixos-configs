# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/huawei/machc-wa>
      ./hardware-configuration.nix
      ./packages.nix
      # Uncomment the relevant desktop environment:
      # ./hyprland.nix
      # ./gnome.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.efi.canTouchEfiVariables = true;

  # bluetooth support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # VBox only
  # fsck will fail under vbox and cause a boot to hang, so turn it off
  boot.initrd.checkJournalingFS = false;
  # End VBox only

  networking.hostName = "matebook";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "sv_SE.UTF-8";

  time.timeZone = "Europe/Stockholm";

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    shellAliases = {
      vi = "nvim";
    };
  };
  users.defaultUserShell = pkgs.zsh;
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.defaultEditor = true;
  programs.npm.enable = true;
  programs.less.enable = true;
  programs.iftop.enable = true;
  programs.java.enable = true;

  services.mpd = {
    enable = true;
    startWhenNeeded = true;
  };

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  services.acpid.enable = true;
  location.latitude = 63.825848;
  location.longitude = -20.263035;

  services.openssh.enable = true;

  networking.firewall.enable = false;
  # Spotify ports for Chromecasts and mobile phones
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];

  services.printing.enable = true;

  sound.enable = true;

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

  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.layout = "se";
  services.xserver.xkbVariant = "mac";

  security.polkit.enable = true;

  users.users.elias = {
    isNormalUser = true;
    description = "Elias Renman";
    home = "/home/elias";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "18.09";

  services.logind.extraConfig = ''
    # don't shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.variables = {
    PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Nvidia driver configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "elias" ];
}
