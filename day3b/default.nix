{
  pkgs ? import <nixpkgs> { },
  buildGoModule ? pkgs.buildGoModule,
  ...
}:
buildGoModule rec {
  name = "day3b";
  src = ./.;
  vendorHash = null;
  postInstall = ''
    mv $out/bin/main $out/bin/${name}
  '';
}
