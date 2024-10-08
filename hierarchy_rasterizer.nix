{ lib
, ninja
, which
, python3
, cudaPackages
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hierarchy-rasterizer";
  version = "unstable-2024-08-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "graphdeco-inria";
    repo = "hierarchy-rasterizer";
    rev = "63fa247628379b993364d720f31b5fe97f3d7ab9";
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
    description = "hierarchy rasterizer";
    homepage = "https://github.com/graphdeco-inria/hierarchy-rasterizer";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    mainProgram = "hierarchy-rasterizer";
  };
}
