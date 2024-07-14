#!/usr/bin/env bash

nix flake update /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
