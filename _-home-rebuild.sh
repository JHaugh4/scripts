#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

nix flake update /etc/nixos
home-manager switch --flake "/etc/nixos#jhaugh@$machine"
