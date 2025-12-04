{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day4a";
  src = ./.;

  nativeBuildInputs = [
    pkgs.jdk25_headless
  ];
  buildInputs = [
    pkgs.jre
    pkgs.makeWrapper
  ];

  buildPhase = ''
    mkdir classes
    javac -d classes Main.java
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java/classes/

    cp -r classes/* $out/share/java/classes

    makeWrapper ${pkgs.jre}/bin/java $out/bin/${name} \
      --add-flags "-classpath $out/share/java/classes Main ${./input.txt}"
  '';
}
