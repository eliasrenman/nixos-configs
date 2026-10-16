# CLI tools and development toolchains - shared by all machines
{ config, pkgs, inputs, ... }:

let
  claude-code = pkgs.callPackage ./modules/claude-code.nix {};
  llm-pkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  codegraph = inputs.codegraph.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
    npmDeps = pkgs.fetchNpmDeps {
      src = inputs.codegraph;
      hash = "sha256-J8viY38M/loCoJmpxEOIApN6cpf6sU2aa80knVNRSvI=";
    };
    # npm puts the root workspace's Vite 5 ahead of the UI's Vite 7 when
    # running workspace scripts. Svelte plugin 6 requires Vite 6 or newer.
    preBuild = ''
      substituteInPlace ui/package.json \
        --replace-fail '"build": "vite build"' '"build": "node ./node_modules/vite/bin/vite.js build"'
    '';
    postInstall = ''
      rm -f $out/lib/codegraph/node_modules/@colbymchenry/codegraph-ui
    '';
  });
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
    ripgrep
    bat
    eza
    gh
    tea
    killall
    glances
    qmk
    claude-code
    codegraph

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
