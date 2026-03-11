{ config, pkgs, lib, ... }:

let
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
      mkdir -p $out/share/bat/themes
      cp extras/sublime/*.tmTheme $out/share/bat/themes/
    '';
  };
in
{
  environment.systemPackages = [ bat-tokyonight ];

  # Install themes for all users and rebuild cache
  system.activationScripts.batTokyonightThemes = lib.stringAfter [ "users" ] ''
    for dir in /home/*; do
      if [ -d "$dir" ]; then
        user=$(basename "$dir")
        mkdir -p "$dir/.config/bat/themes"
        cp -f ${bat-tokyonight}/share/bat/themes/*.tmTheme "$dir/.config/bat/themes/" 2>/dev/null || true
        chown -R "$user:users" "$dir/.config/bat" 2>/dev/null || true
        # Rebuild bat cache as user
        HOME="$dir" ${pkgs.bat}/bin/bat cache --build 2>/dev/null || true
      fi
    done
  '';
}
