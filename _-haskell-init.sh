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
CABALNAME=$(basename "$PWD")
# Ask the user if this is correct
read -p "Cabal project name: $CABALNAME, is this correct? (y/n)" CONFIRM
# If they named it something else
if [[ ${CONFIRM^^} == 'N' ]]; then
    # Then ask them for the name
    read -p "Enter cabal project name: " CABALNAME
fi
# Now we can setup the shell.nix file
cat > "shell.nix" <<- EOM
{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    cabal-install
    ghc
    haskell-language-server
  ];
  inputsFrom = [ (pkgs.haskellPackages.callCabal2nix "$CABALNAME" ./. { }).env ];
}
EOM
# Now set up the .envrc direnv file
cat > ".envrc" <<- EOM
watch_file $CABALNAME.cabal
use nix
EOM
# Finally allow direnv
direnv allow
