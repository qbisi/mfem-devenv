{
  description = "A basic flake with a shell";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:qbisi/nixpkgs/mfem";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { config, pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          devShells = rec {
            default = pkgs.mkShell {
              packages = with pkgs; [
                mfem mpi cmake lapack blas
              ];
              shellHook = ''
                export MFEM_INSTALL_DIR=${pkgs.mfem}
              '';
            };

            python = pkgs.mkShell {
              packages = with pkgs; [
                (python3.withPackages (
                  ps: with ps; [
                    packaging
                    setuptools
                  ]
                ))
              ];
            };
          };

          packages = {
            mfem = pkgs.mfem;
          };
        };
    };
}
