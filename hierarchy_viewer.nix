{ lib
, stdenv
, cmake
, git
, glew, assimp, boost, gtk3, opencv, glfw3, eigen, embree, ffmpeg_7-headless, xorg  
, fetchFromGitLab
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "hierarchy_viewer";
  version = "0.1.0";

  srcs = [
    (fetchFromGitLab {
      domain = "gitlab.inria.fr";
      owner = "sibr";
      repo = "sibr_core";
      rev = "0103f7fd75deb0f392c339c74a4ec1cf728e31d1";
      name = "sibr";
      hash = "sha256-XgVySMZwa8wZbqGyyzkqd1jn9mI9XaJR039xAr03VtU=";
    })
    (fetchFromGitHub {
      owner = "graphdeco-inria";
      repo = "hierarchy-viewer";
      rev = "011f8c5bce44e6d3b6ca9e6f29538107743b55a4";
      name = "hierarchyviewer";
      hash = "sha256-Ndf+RNMod1UunNztsBeQX4OtRPtnVCVA9V182ahh0ec=";
      #fetchSubmodules = true;
    })
  ];

  sourceRoot = "sibr"; 

  #  src = stdenv.mkDerivation {
  #    name = "hierarchy_viewer_combined-src";
  #    sibr_src= sibr_src;
  #    project_src = project_src;
  #
  #    postUnpack = ''
  #      mkdir $out
  #      cp -r $sibr_src/* $out/
  #      mkdir -p $out/src/projects/hierarchyviewer
  #      cp -r $project_src/* $out/src/projects/hierarchyviewer/
  #    '';
  #  };

  preConfigure = ''
    chmod -R +w hierarchyviewer
    mv hierarchyviewer sibr/src/projects/
    export ASSIMP_DIR=${assimp}
  '';

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ glew assimp boost gtk3 opencv glfw3 eigen embree ffmpeg_7-headless xorg.libXxf86vm ];

  #doCheck = enableTests;

  #cmakeFlags = lib.optional (!enableTests) "-DTESTING=off";
}
