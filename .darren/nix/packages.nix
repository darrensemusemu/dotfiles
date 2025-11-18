# Cross-platform package list
# These packages work on both macOS and Linux
# Installed via: nix-env -iA packages -f ~/.darren/nix/default.nix

{ pkgs }:

with pkgs; [
  # Editors (confirmed usage)
  neovim
  vim-full                 # Vim with GUI support (gvim) - replaces 'vim'

  # Terminal & Shell (confirmed usage)
  # ghostty            # On Linux: via Nix (see Linux section below)
                       # On macOS: via Homebrew cask (see packages.brew.txt)
  tmux
  zsh
  zsh-completions

  # CLI Tools (confirmed active usage)
  fzf                  # Fuzzy finder - heavily used in scripts
  git
  jq                   # JSON processor
  nmap

  # Uncomment when you want to explore/add:
  # ripgrep            # Better grep (rg) - currently using claude-code's version
  # fd                 # Better find
  # bat                # cat with syntax highlighting
  # eza                # modern ls
  # zoxide             # smarter cd

  # Development (uncomment as needed)
  # go                 # Not currently installed
  # nodejs             # Currently via brew/system
  # python3            # Currently via brew/system (3.13.7)
  # rustc              # Not currently installed

] ++ lib.optionals stdenv.isLinux [
  # Linux-only packages
  xclip              # X11 clipboard
  ghostty            # Modern terminal emulator

  # Note: Browsers removed - use native package manager for faster security updates
  # On Arch: See ~/.darren/packages.pacman.txt for browser recommendations

] ++ lib.optionals stdenv.isDarwin [
  # macOS-only packages (add as needed)

  # Note: For GUI apps on macOS (browsers, etc), use Homebrew
  # See: ~/.darren/packages.brew.txt
]
