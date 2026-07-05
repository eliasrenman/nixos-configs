# CLI tools and development toolchains - shared by all machines
{ config, pkgs, inputs, ... }:

let
  claude-code = pkgs.callPackage ./modules/claude-code.nix {};
  llm-pkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  pipx = pkgs.pipx.overridePythonAttrs (_: {
    doCheck = false;
  });
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
    python3
    go
    bun
    pipx
    corepack

    # CLI tools
    fastfetch
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

    # LLM agents
    llm-pkgs.pi
    llm-pkgs.mistral-vibe
    llm-pkgs.codex

    # Container tools
  ];
}
