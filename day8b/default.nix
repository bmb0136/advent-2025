{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day8b";
  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share

    cp input.txt $out/share/
    cp main.rb $out/share/

    makeWrapper ${pkgs.ruby}/bin/ruby $out/bin/${name} \
      --add-flags "$out/share/main.rb $out/share/input.txt"
  '';
}
