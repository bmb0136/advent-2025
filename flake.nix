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
          {
            self',
            pkgs,
            lib,
            ...
          }:
          let
            names = builtins.attrNames self'.packages;
            days = builtins.filter (lib.strings.hasInfix "day") names;
            sortFunc = x: y: if (builtins.stringLength x) < (builtins.stringLength y) then true else builtins.lessThan x y;
            sorted = builtins.sort sortFunc days;
          in
          {
            treefmt = import ./treefmt.nix;

            packages.default = self'.packages.${lib.lists.last sorted};

            packages.all = pkgs.writeShellApplication {
              name = "all";

              runtimeInputs = builtins.map (x: self'.packages.${x}) sorted;

              text = ''
                for x in ${lib.strings.join " " sorted}; do
                  echo $x
                  $x
                done
              '';
            };

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
            packages.day7a = pkgs.callPackage ./day7a { };
            packages.day7b = pkgs.callPackage ./day7b { };
            packages.day8a = pkgs.callPackage ./day8a { };
            packages.day8b = pkgs.callPackage ./day8b { };
            packages.day9a = pkgs.callPackage ./day9a { };
            packages.day9b = pkgs.callPackage ./day9b { };
            packages.day10a = pkgs.callPackage ./day10a { };
            packages.day10b = pkgs.callPackage ./day10b { };
          };
      }
    );
}
