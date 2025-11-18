#!/usr/bin/env bash
# Install packages from .darren/nix/packages.nix
# Usage: ~/.darren/nix/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing packages from $SCRIPT_DIR/default.nix..."
echo "Using replace mode: packages.nix is the source of truth"
nix-env -irA packages -f "$SCRIPT_DIR/default.nix"

echo ""
echo "Installation complete!"
echo ""
echo "Installed packages:"
nix-env -q
