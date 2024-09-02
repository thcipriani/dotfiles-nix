#!/usr/bin/env bash

echo "Building nix flake..."
nix run . -- build --flake .
echo "Switching to nix flake..."
nix run . -- switch --flake .
