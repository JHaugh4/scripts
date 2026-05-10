#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=_-rebuild-common.sh
source "$(dirname "$0")/_-rebuild-common.sh"

if [[ $# -ge 1 ]]; then
    machine="$1"
else
    machine=$(pick_machine)
fi

cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake ".#$machine"
