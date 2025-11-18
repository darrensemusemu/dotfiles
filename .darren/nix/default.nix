# Default entry point for .darren/nix
# Usage: nix-env -iA packages -f ~/.darren/nix/default.nix

{ pkgs ? import <nixpkgs> {} }:

{
  # Package list for cross-platform installation
  packages = import ./packages.nix { inherit pkgs; };
}
