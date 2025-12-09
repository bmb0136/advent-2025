{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day9a";
  src = ./.;

  nativeBuildInputs = [
    pkgs.makeWrapper
    (pkgs.haskellPackages.ghcWithPackages (p: with p; [split text]))
  ];

  buildPhase = ''
    ghc main.hs
  '';

  installPhase = ''
    mkdir -p $out/share
    mkdir -p $out/bin

    cp input.txt $out/share/
    cp main $out/bin/

    makeWrapper $out/bin/main $out/bin/${name} \
      --add-flags "$out/share/input.txt"
  '';
}
