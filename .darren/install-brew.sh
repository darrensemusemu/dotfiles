#!/usr/bin/env bash
# Install GUI apps from packages.brew.txt (macOS only)
# Usage: ~/.darren/install-brew.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREW_FILE="$SCRIPT_DIR/packages.brew.txt"

# Check if on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only (Homebrew casks for GUI apps)"
  echo "On Linux, use Nix to install browsers: nix-env -iA packages -f ~/.darren/nix/default.nix"
  exit 0
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Install from: https://brew.sh"
  exit 1
fi

echo "Installing GUI applications from $BREW_FILE..."
echo ""

# Filter out comments and empty lines, then install
grep -v '^#' "$BREW_FILE" | grep -v '^$' | while read -r package; do
  echo "Installing: $package"
  brew install --cask "$package" || echo "Warning: Failed to install $package"
done

echo ""
echo "Installation complete!"
echo ""
echo "Installed casks:"
brew list --cask
