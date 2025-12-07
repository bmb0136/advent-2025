{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "day1a";
  src = ./.;
  nativeBuildInputs = [
    pkgs.makeWrapper
  ];
  postInstall = ''
    cp input.txt $out/share/

    makeWrapper $out/share/bin/${name} $out/bin/${name} \
      --add-flags "$out/share/input.txt"
  '';

  PREFIX = "\${out}/share";
}
