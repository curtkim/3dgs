{ lib
, cmake
, ninja
, which
, python3
, cudaPackages
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "gaussian-hierarchy";
  version = "unstable-2024-08-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "graphdeco-inria";
    repo = "gaussian-hierarchy";
    rev = "677c8553dc64dfd62c272eca94a291a277733113";
    hash = "sha256-k1Scx1PFl248/xNgeM7vGcF5+Izv63tgZ9PXCz9zvqU=";
    fetchSubmodules = true;
  };

  stdenv = cudaPackages.backendStdenv;

  # 빌드 전에 필요한 환경 변수 설정
  preBuild = ''
    export CUDA_HOME=${cudaPackages.cudatoolkit}
    export TORCH_CUDA_ARCH_LIST="8.6"
  '';

  nativeBuildInputs = [
    ninja
    which
    python3.pkgs.setuptools
  ];
  buildInputs = [
    cudaPackages.cudatoolkit   # CUDA Toolkit을 포함
    python3.pkgs.pybind11
  ];

  propagatedBuildInputs = with python3.pkgs; [
    torchWithCuda
  ];

  pythonImportsCheck = [ "diff_gaussian_rasterization" ];

  meta = with lib; {
    description = "gaussian hierarchy";
    homepage = "https://github.com/graphdeco-inria/gaussian-hierarchy";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    mainProgram = "gaussian-hierarchy";
  };
}
