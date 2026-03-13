# Zen Browser with declarative extensions and search engine
{ config, pkgs, ... }:

let
  zen-browser-src = builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz";
  zen-browser-pkgs = import zen-browser-src { inherit pkgs; };

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
  ];
in
{
  environment.systemPackages = [
    (pkgs.wrapFirefox zen-browser-pkgs.zen-browser-unwrapped {
      pname = "zen-browser";
      extraPolicies = {
        DisableTelemetry = true;
        ExtensionSettings = builtins.listToAttrs extensions;
        SearchEngines = {
          Default = "Ecosia";
          Add = [
            {
              Name = "Ecosia";
              URLTemplate = "https://www.ecosia.org/search?q={searchTerms}";
              IconURL = "https://www.ecosia.org/favicon.ico";
              Alias = "@eco";
            }
          ];
        };
      };
    })
  ];
}
