cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake .#nixos
