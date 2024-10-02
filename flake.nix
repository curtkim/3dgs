{
  description = "3dgs";

  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org/"
      "https://cuda-maintainers.cachix.org"
      #"https://curtkim.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      #"curtkim.cachix.org-1:vE/5QMP9QEKKAUIfyzQoe5rBLrkyKsqJ0pBRui3u1gE="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system: let
      myOverlays = [
        #        (final: prev: rec {
        #          colmapWithCuda12 = prev.colmapWithCuda.override({ mkDerivation = prev.gcc12Stdenv.mkDerivation;});
        #          colmapWithCuda = colmapWithCuda12.overrideAttrs(oldAttrs: {
        #            cmakeFlags = [
        #              "-DCUDA_ENABLED=ON"
        #              "-DCUDA_NVCC_FLAGS=--std=c++14"
        #              "-DCUDA_ARCHS=8.6"
        #            ];
        #          });
        #        })

        #       (final: prev: {
        #          python311 = prev.python311.override {
        #            packageOverrides = pfinal: pprev: {
        #              opencv4 = pprev.opencv4.overrideAttrs (oldAttrs: {
        #                postUnpack = null;
        #                patches = [ (builtins.head oldAttrs.patches) ] ;
        #              });
        #            };
        #          };
        #        })

         (final: prev: {
            python311 = prev.python311.override {
              packageOverrides = pfinal: pprev: {
                opencv4 = pprev.opencv4.override {enableCuda=false; enableContrib=false;};
              };
            };
          })
      ];

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
        overlays = myOverlays;
      };

      hierarchy_rasterizer = pkgs.callPackage ./hierarchy_rasterizer.nix {};
      gaussian-hierarchy = pkgs.callPackage ./gaussian-hierarchy.nix {};
      simple-knn = pkgs.callPackage ./simple-knn.nix {};
      hierarchy_viewer = pkgs.callPackage ./hierarchy_viewer.nix {};
      gaussian-splatting-lightning = pkgs.callPackage ./gaussian-splatting-lightning.nix {
        simple-knn = simple-knn;
        #hierarchy_rasterizer = hierarchy_rasterizer;
      };

    in {
      packages.hierarchy_rasterizer = hierarchy_rasterizer;
      packages.gaussian-hierarchy = gaussian-hierarchy;
      packages.simple-knn = simple-knn;
      packages.hierarchy_viewer = hierarchy_viewer;
      packages.colmapWithCuda = pkgs.colmapWithCuda;
      packages.default = pkgs.colmapWithCuda; #gaussian-splatting-lightning; #hierarchy_rasterizer;

      devShells.hierarchy_rasterizer = hierarchy_rasterizer;
      devShells.gaussian-hierarchy = gaussian-hierarchy;
      devShells.simple-knn = simple-knn;
      devShells.hierarchy_viewer = hierarchy_viewer;
      #devShells.default = hierarchy_rasterizer;

      devShells.colmapWithCuda = pkgs.colmapWithCuda;
      #devShells.default = gaussian-splatting-lightning;

      devShells.default = pkgs.mkShell {
        #stdenv = pkgs.cudaPackages.backendStdenv;
        packages = [
          #pkgs.opencv
          pkgs.colmapWithCuda
          #pkgs.opensplatWithCuda
          #gaussian-splatting-lightning
          (pkgs.python3.withPackages (ps: [
            #ps.opencv4
          ]))
        ];
      };
    });
}

