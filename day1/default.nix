{ pkgs ? import <nixpkgs> {}, ... }: pkgs.stdenv.mkDerivation {
  name = "day1";
  src = ./.;
  PREFIX = "\${out}";
}
