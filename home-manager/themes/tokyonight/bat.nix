{ config, pkgs, lib, ... }:

let
  # Fetch tokyonight theme for bat
  bat-tokyonight = pkgs.stdenv.mkDerivation {
    pname = "bat-tokyonight";
    version = "2024-01-01";

    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "tokyonight.nvim";
      rev = "main";
      sha256 = "sha256-4zfkv3egdWJ/GCWUehV0MAIXxsrGT82Wd1Qqj1SCGOk=";
    };

    installPhase = ''
      mkdir -p $out/themes
      cp extras/sublime/*.tmTheme $out/themes/
    '';
  };
in
{
  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight_night";
    };
  };

  # Install tokyonight theme files
  home.file.".config/bat/themes" = {
    source = "${bat-tokyonight}/themes";
    recursive = true;
  };

  # Rebuild bat cache on activation
  home.activation.batCacheRebuild = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --build 2>/dev/null || true
  '';
}
