{
  pkgs ? import <nixpkgs> { },
  buildGoModule ? pkgs.buildGoModule,
  ...
}:
buildGoModule {
  name = "day3a";
  src = ./.;
  vendorHash = null;
  postInstall = ''
    mv $out/bin/main $out/bin/day3a
  '';
}
