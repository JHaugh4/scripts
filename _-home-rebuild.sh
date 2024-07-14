#!/usr/bin/env bash

nix flake update /etc/nixos
home-manager switch --flake /etc/nixos#jhaugh@nixos
