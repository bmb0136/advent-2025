{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "day1b";
  src = ./.;
  PREFIX = "\${out}";
}
