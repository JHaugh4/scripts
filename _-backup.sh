#!/usr/bin/env bash
# Exit on error
set -e
# Backup home folder and nixos config
restic -r "$BACKUP_DIR/restic-repo" --verbose --exclude-file="$HOME/.config/restic/exclude.txt" backup "$HOME/" /etc/nixos/
