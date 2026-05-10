#!/usr/bin/env bash
set -euo pipefail

declare -f pick_machine > /dev/null 2>&1 || source "$(dirname "$0")/_-rebuild-common.sh"

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake ".#$machine"
