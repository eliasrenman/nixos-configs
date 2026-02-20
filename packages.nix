{ config, pkgs, fetchurl, ... }:

{
  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    stow
    sudo
    ncdu

    gzip
    unar
    unzip
    zsh

    # Build toolchains
    autoconf
    automake
    gnumake
    scons
    cmake
    gcc8
    clang
    clang-analyzer
    clang-manpages
    clang-tools
    pipx
    bun
    pkg-config
    openssl
    go
    docker
    SDL2
    libxcrypt

    rustup
    python3
    nodejs_18
    corepack

    # GUI tools
    kicad-small
    xfce.thunar
    xfce.thunar-archive-plugin
    libsForQt5.koko
    firefox
    alacritty
    vlc
    pavucontrol
    discord
    spotify
    jetbrains-toolbox
    aseprite
    godot_4
    alsa-tools
    insomnia

    # CLI Tools
    neofetch
    bat
    eza
    gh
    brightnessctl
    killall
    pamixer
    glances
    spotify-tui
    spotifyd

    # Media
    ffmpeg-full
    playerctl

    # IDEs
    neovim
    vscode

    # FPV related
    betaflight-configurator
    chromium
  ];
}
