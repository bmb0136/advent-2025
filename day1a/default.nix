{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "day1a";
  src = ./.;
  PREFIX = "\${out}";
}
