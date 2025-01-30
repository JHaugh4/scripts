#!/usr/bin/env bash
# Exit on error
set -e

# Setup the shell.nix
cat > "shell.nix" <<- EOM
{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    
  ];
}
EOM

# Now set up the .envrc direnv file
cat > ".envrc" <<- EOM
use nix
EOM

# Finally allow direnv
direnv allow