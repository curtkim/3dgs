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
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = ["8.6"];
          cudaEnableForwardCompat = false;
          permittedInsecurePackages = [
            "freeimage-unstable-2021-11-01"
          ];
        };
      };
      hierarchy_rasterizer = pkgs.callPackage ./hierarchy_rasterizer.nix {};
      gaussian-hierarchy = pkgs.callPackage ./gaussian-hierarchy.nix {};
      simple-knn = pkgs.callPackage ./simple-knn.nix {};
      hierarchy_viewer = pkgs.callPackage ./hierarchy_viewer.nix {};

    in {
      packages.hierarchy_rasterizer = hierarchy_rasterizer;
      packages.gaussian-hierarchy = gaussian-hierarchy;
      packages.simple-knn = simple-knn;
      packages.hierarchy_viewer = hierarchy_viewer;
      packages.default = hierarchy_rasterizer;

      devShells.hierarchy_rasterizer = hierarchy_rasterizer;
      devShells.gaussian-hierarchy = gaussian-hierarchy;
      devShells.simple-knn = simple-knn;
      devShells.hierarchy_viewer = hierarchy_viewer;
      #devShells.default = hierarchy_rasterizer;

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.colmapWithCuda
          (pkgs.python3.withPackages (ps: [

          ]))
        ];
      };
    });
}

