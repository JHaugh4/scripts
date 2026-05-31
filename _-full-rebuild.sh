#!/usr/bin/env bash
set -euo pipefail

check_repo_sync $nixos_dir

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

cd $nixos_dir
nix flake update
sudo nixos-rebuild switch --flake "$nixos_dir#$machine"
