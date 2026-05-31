#!/usr/bin/env bash
set -euo pipefail

check_repo_sync $nixos_dir

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

nix flake update $nixos_dir
home-manager switch --flake "$nixos_dir#jhaugh@$machine"
