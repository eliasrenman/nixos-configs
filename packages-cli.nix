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
    python3
    python3Packages.pip
    go
    bun
    pipx
    corepack

    # CLI tools
    neofetch
    bat
    eza
    gh
    killall
    glances
    qmk
    claude-code

    # Editors
    neovim

    # Media
    ffmpeg-full

    # Container tools
    docker
  ];
}
