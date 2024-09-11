{
  description = "3dgs";

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org/"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      hierarchy_rasterizer = pkgs.callPackage ./hierarchy_rasterizer.nix {};
    in {
      packages.hierarchy_rasterizer = hierarchy_rasterizer;
      packages.default = hierarchy_rasterizer;
      devShells.default = hierarchy_rasterizer;
    });
}

