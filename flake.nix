{
  description = "A basic flake with a shell";

  inputs = {
    # wait for pr
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:qbisi/nixpkgs/mfem";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    mfem = {
      # change url to your own mfem repository
      # url = "/home/<user>/mfem-devenv/mfem";
      url = "github:mfem/mfem/v4.7";
      flake = false;
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
            mfem = pkgs.mfem.overrideAttrs {
              src = inputs.mfem;
            };
          };
        };
    };
}
