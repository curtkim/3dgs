{ lib
, ninja
, which
, python3
, cudaPackages
, fetchFromGitLab
}:

python3.pkgs.buildPythonPackage rec {
  pname = "simple-knn";
  version = "unstable-2024-08-07";
  format = "setuptools";

  src =fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "bkerbl";
    repo = "simple-knn";
    rev = "86710c2d4b46680c02301765dd79e465819c8f19";
    hash = "sha256-ZRfQ2CR9w3onwE+9rNz8RPFh7Hy0Le7zju9m1Vh9y/8=";
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

  pythonImportsCheck = [ "simple_knn" ];

  meta = with lib; {
    description = "simple cuda knn";
    homepage = "https://gitlab.inria.fr/bkerbl/simple-knn/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    mainProgram = "simple-knn";
  };
}
