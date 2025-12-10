{
  pkgs ? import <nixpkgs> {},
  dotnetCorePackages ? pkgs.dotnetCorePackages,
  ...
}: pkgs.buildDotnetModule rec {
  name = "day10a";
  src = ./.;
  version = "1.0";

  nativeBuildInputs = [pkgs.makeWrapper];
  projectFile = "${name}.fsproj";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;

  executables = [];
  selfContainedBuild = true;
  postInstall = ''
    mkdir -p $out/share
    mkdir -p $out/bin

    cp input.txt $out/share/

    makeWrapper $out/lib/${name} $out/bin/${name} \
      --add-flags "$out/share/input.txt"
  '';
}
