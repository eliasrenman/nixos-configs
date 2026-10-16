{
  description = "NixOS configuration for all machines";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    llm-agents.url = "github:numtide/llm-agents.nix";
    codegraph.url = "github:CUexter/codegraph/cfe961b5ccac8c9b858e2261dd66d85a9ea3fe16";
    # Keep the requested Nix flake available, while building from upstream's
    # latest stable release so the package does not lag behind this branch.
    rtk.url = "github:arnemileswinter/rtk/feat/nix-flake";
    rtk-upstream = {
      url = "github:rtk-ai/rtk/v1.0.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, llm-agents, codegraph, rtk, rtk-upstream, ... }@inputs: {
    nixosConfigurations = {
      minipc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./host-minipc.nix
        ];
      };

      matebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./host-laptop.nix
        ];
      };

      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./host-wsl.nix
        ];
      };
    };
  };
}
