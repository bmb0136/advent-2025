{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day2b";
  src = ./.;

  nativeBuildInputs = [ pkgs.rustc ];

  buildPhase = ''
    rustc main.rs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin/${name}
  '';
}
