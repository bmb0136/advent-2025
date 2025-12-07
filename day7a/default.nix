{
  pkgs ? import <nixpkgs> {},
  ...
}: pkgs.stdenv.mkDerivation rec {
  name = "day7a";
  src = ./.;

  nativeBuildInputs = [pkgs.makeWrapper];

  installPhase = ''
    mkdir -p $out/share

    cp input.txt $out/share/
    cp main.dart $out/share/

    makeWrapper ${pkgs.dart}/bin/dart $out/bin/${name} \
      --add-flags "run $out/share/main.dart $out/share/input.txt"
  '';
}
