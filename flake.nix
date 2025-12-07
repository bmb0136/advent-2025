{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [
          "x86_64-linux"
        ];

        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        perSystem =
          { pkgs, ... }:
          {
            treefmt = import ./treefmt.nix;

            packages.day1a = pkgs.callPackage ./day1a { };
            packages.day1b = pkgs.callPackage ./day1b { };
            packages.day2a = pkgs.callPackage ./day2a { };
            packages.day2b = pkgs.callPackage ./day2b { };
            packages.day3a = pkgs.callPackage ./day3a { };
            packages.day3b = pkgs.callPackage ./day3b { };
            packages.day4a = pkgs.callPackage ./day4a { };
            packages.day4b = pkgs.callPackage ./day4b { };
            packages.day5a = pkgs.callPackage ./day5a { };
            packages.day5b = pkgs.callPackage ./day5b { };
            packages.day6a = pkgs.callPackage ./day6a { };
            packages.day6b = pkgs.callPackage ./day6b { };
          };
      }
    );
}
