{
  description = "My keyboard configurations";

  inputs = {
    nixpkgs.url = "git+https://github.com/mulatta/nixpkgs?shallow=1&ref=main";
    qmk-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mulatta/qmk-nix";
    };
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      qmk-nix,
      treefmt-nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      treefmtEval = eachSystem (
        { pkgs, ... }:
        treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            deadnix.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
          };
        }
      );
    in
    {
      checks = eachSystem (
        { system, ... }:
        {
          firmware = self.packages.${system}.firmware;
          formatting = treefmtEval.${system}.config.build.check self;
        }
      );

      devShells = eachSystem (
        { pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.qmk
              pkgs.zapp
            ];
          };
        }
      );

      formatter = eachSystem ({ system, ... }: treefmtEval.${system}.config.build.wrapper);

      packages = eachSystem (
        { pkgs, system }:
        let
          firmware = pkgs.callPackage ./nix/zsa-firmware.nix {
            inherit (qmk-nix.legacyPackages.${system}) buildQmkFirmware;
          };
          flash = pkgs.writeShellApplication {
            name = "zsa-flash";
            runtimeInputs = [ pkgs.zapp ];
            text = ''
              zapp flash ${firmware}/firmware.bin
            '';
          };
        in
        {
          default = firmware;
          inherit firmware flash;
        }
      );
    };
}
