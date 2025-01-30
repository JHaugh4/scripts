#!/usr/bin/env bash
# Exit on error
set -e
# Setup the shell.nix
cat > "shell.nix" <<- EOM
{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
    ]))
  ];
}
EOM
# Now set up the .envrc direnv file
cat > ".envrc" <<- EOM
watch_file *.cabal
use nix
EOM
# Finally allow direnv
direnv allow
