{
  pkgs ? import <nixpkgs> {}
}: pkgs.stdenv.mkDerivation rec {
  name = "day5b";
  src = ./.;

  nativeBuildInputs = [pkgs.makeWrapper];

  buildPhase = ''
    mkdir -p $out/share/elixir
    mkdir -p $out/share/data
    cp main.exs $out/share/elixir
    cp input.txt $out/share/data
  '';

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.beamMinimal28Packages.elixir}/bin/elixir $out/bin/${name} \
      --add-flags "$out/share/elixir/main.exs $out/share/data/input.txt"
  '';
}
