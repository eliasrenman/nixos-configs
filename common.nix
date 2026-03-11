# Common configuration shared by all machines
{ config, pkgs, ... }:

{
  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  # Locale and timezone
  i18n.defaultLocale = "sv_SE.UTF-8";
  time.timeZone = "Europe/Stockholm";

  # Shell configuration
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    shellAliases = {
      vi = "nvim";
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # Common programs
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.defaultEditor = true;
  programs.npm.enable = true;
  programs.less.enable = true;
  programs.iftop.enable = true;
  programs.java.enable = true;

  # User definition
  users.users.elias = {
    isNormalUser = true;
    description = "Elias Renman";
    home = "/home/elias";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" "dialout" ];
  };

  # Docker configuration
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "8.8.8.8" "8.8.4.4" ];
    };
  };

  # SSH
  services.openssh.enable = true;

  # Environment variables
  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LANGUAGE = "en_US:en";  # Force English messages for Git and other programs
  };
}
