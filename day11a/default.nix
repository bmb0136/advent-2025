{
  pkgs ? import <nixpkgs> {},
  ...
}: pkgs.stdenv.mkDerivation rec {
  name = "day11a";
  src = ./.;

  nativeBuildInputs = [pkgs.makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share

    cp main.py $out/share/
    cp input.txt $out/share/

    makeWrapper ${pkgs.python3}/bin/python3 $out/bin/${name} \
      --add-flags "$out/share/main.py $out/share/input.txt"
  '';
}
