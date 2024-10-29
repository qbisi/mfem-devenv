# mfem devenv powered by nixpkgs

This repository contains basic requirement to build and run mfem examples.
Requires nix and direnv.
nix requires flake enabled.
```
apt install nix direnv
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf
git clone --recurse-submodules https://qbisi/mfem-devenv ~/mfem-devenv
direnv allow ~/mfem-devenv
```

## develop mfem
To develop build of mfem, see .envrc.