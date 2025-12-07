{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day6b";
  src = ./.;

  nativeBuildInputs = [
    pkgs.kotlin
    pkgs.makeWrapper
  ];

  buildPhase = ''
    kotlinc -d main.jar -include-runtime main.kt
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share

    cp main.jar $out/share/
    cp input.txt $out/share/

    makeWrapper ${pkgs.jre}/bin/java $out/bin/${name} \
      --add-flags "-jar $out/share/main.jar $out/share/input.txt"
  '';
}
