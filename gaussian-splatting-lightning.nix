{pkgs
, simple-knn 
#,hierarchy_rasterizer
, fetchFromGitHub
, ninja
, which
, cudaPackages
}:
let
  python3 = pkgs.python3;
  pythonPackages = python3.pkgs;
in
  pythonPackages.buildPythonPackage {
    pname = "gaussian-splatting-lightning";
    version = "v0.9.0";  # You may want to adjust this version

    src = fetchFromGitHub {
      owner = "yzslab";
      repo = "gaussian-hierarchy";
      rev = "v0.9.0";
      hash = "sha256-k1Scx1PFl248/xNgeM7vGcF5+Izv63tgZ9PXCz9zvqU=";
      fetchSubmodules = false;
    };
    format = "pyproject";
    stdenv = cudaPackages.backendStdenv;

    # 빌드 전에 필요한 환경 변수 설정
    preBuild = ''
      export CUDA_HOME=${cudaPackages.cudatoolkit}
      export TORCH_CUDA_ARCH_LIST="8.6"
    '';

    nativeBuildInputs = [
      ninja
      which
      pythonPackages.setuptools
    ];

    buildInputs = [
      cudaPackages.cudatoolkit   # CUDA Toolkit을 포함
      python3.pkgs.pybind11
    ];

    propagatedBuildInputs = with pythonPackages; [
      torchWithCuda
      pytorch-lightning
      #splines
      plyfile
      tensorboard
      wandb
      tqdm
      #viser
      opencv4
      matplotlib
      mediapy
    ] ++ [
      simple-knn
      #hierarchy_rasterizer
    ];

    doCheck = false;  # Disable tests if they're not set up properly
  }
