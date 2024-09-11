{ lib
, cmake
, ninja
, python3
, cudaPackages
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hierarchy-rasterizer";
  version = "unstable-2024-08-07";
  pyproject = false;

  stdenv = cudaPackages.backendStdenv;

  src = fetchFromGitHub {
    owner = "graphdeco-inria";
    repo = "hierarchy-rasterizer";
    rev = "63fa247628379b993364d720f31b5fe97f3d7ab9";
    hash = "sha256-k1Scx1PFl248/xNgeM7vGcF5+Izv63tgZ9PXCz9zvqU=";
    fetchSubmodules = true;
  };
  env.CUDA_HOME = "${cudaPackages.cudatoolkit}";

  cmakeFlags = [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    cudaPackages.cuda_nvcc
    python3.pkgs.pip
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];
  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl      # cccl = 'cuda c++ compiler'. 없으면 #include <cuda/std/type_traits> 찾다가 에러가 발생한다. 
    python3.pkgs.pybind11
  ];

  propagatedBuildInputs = with python3.pkgs; [
    torchWithCuda
  ];

  pythonImportsCheck = [ "hierarchy_rasterizer" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/graphdeco-inria/hierarchy-rasterizer";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "hierarchy-rasterizer";
  };
}
