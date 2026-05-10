#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake ".#$machine"
