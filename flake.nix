{
  description = "A Nix-flake-based Go development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:

    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (final: prev: { go = prev."go_1_22"; }) ];
        pkgs = import nixpkgs { inherit overlays system; };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # go 1.21 (specified by overlay)
            go

            hugo

            pkgs.nodePackages_latest.sass
          ];
        };
      });
}
