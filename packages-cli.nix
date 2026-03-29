# CLI tools and development toolchains - shared by all machines
{ config, pkgs, ... }:

let
  claude-code = pkgs.callPackage ./modules/claude-code.nix {};
in
{
  environment.systemPackages = with pkgs; [
    # Basic utilities
    wget
    git
    stow
    sudo
    ncdu

    # Compression
    gzip
    unar
    unzip

    # Shell
    zsh
    home-manager

    # Build toolchains
    autoconf
    automake
    gnumake
    scons
    cmake
    gcc
    clang
    clang-analyzer
    clang-manpages
    clang-tools
    pkg-config
    openssl

    # Languages & runtimes
    rustup
    python311
    go
    bun
    pipx
    corepack

    # CLI tools
    neofetch
    bat
    eza
    gh
    tea
    killall
    glances
    qmk
    claude-code
    opencode

    # Editors
    neovim

    # Hardware programming
    arduino-ide

    # Media
    ffmpeg-full

    # Container tools
    docker
  ];
}
