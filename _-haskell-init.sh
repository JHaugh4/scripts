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
{ pkgs , ... }:

pkgs.mkShell {
  packages = with pkgs; [
    cabal-install
    ghc
    haskell-language-server
  ];
  inputsFrom = [ (pkgs.haskellPackages.callCabal2nix "$CABALNAME" ./. { }).env ];
}
EOM
# Then setup the flake to call the shell
cat > "flake.nix" <<- EOM
{
  description = "Default Haskell Flake";

  outputs = {
    self,
    nixpkgs
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.default = import ./shell.nix { inherit pkgs; };
  }
}
}
EOM
# Now set up the .envrc direnv file
cat > ".envrc" <<- EOM
watch_file $CABALNAME.cabal
use flake
EOM
# Finally allow direnv
direnv allow
