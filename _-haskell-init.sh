#!/usr/bin/env bash
# Exit on error
set -e
# Figure out if this is not already a cabal project
if [ ! "$(fd -tf -d 1 -e cabal)" ];
then
    # If it isn't then initialize it
    cabal init
fi
# Try to guess the cabal project name
CABALNAME=$(find . -type f -name "*.cabal" | head -n 1)
CABALNAME=$(basename "$CABALNAME" .cabal)
# Ask the user if this is correct
read -r -p "Cabal project name: $CABALNAME, is this correct? (y/n)" CONFIRM
# If they named it something else
if [[ ${CONFIRM^^} == 'N' ]]; then
    # Then ask them for the name
    read -r -p "Enter cabal project name: " CABALNAME
fi
# Now we can setup the flake.nix file
# '' around EOM prevent variable expansion
# in here doc
cat > "flake.nix" <<- 'EOM'
{
  description = "Default Haskell Flake";

  outputs = {
    self,
    nixpkgs
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = import ./shell.nix { inherit pkgs; };
  };
}
EOM
# Then setup the shell.nix
cat > "shell.nix" <<- 'EOM'
{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    haskell-language-server
  ];
  inputsFrom = [ (pkgs.haskellPackages.callCabal2nix "playground" ./. { }).env ];
}
# EOM
# Now set up the .envrc direnv file
cat > ".envrc" <<- EOM
watch_file *.cabal
use flake
EOM
# Finally allow direnv
direnv allow
