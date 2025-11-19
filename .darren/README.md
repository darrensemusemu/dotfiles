# Dotfiles Setup

Cross-platform dotfiles managed with bare git repo and Nix.

## Prerequisites

### macOS
- **Homebrew** (for GUI applications)
  - Install manually: https://brew.sh
  - Review install script before running: https://github.com/Homebrew/install/blob/HEAD/install.sh
  - Required for: browsers, Ghostty terminal

### Linux (Arch)
- **Nix** (package manager)
  - Install: https://nixos.org/download.html
  - Used for: CLI tools and development packages

### All Platforms
- **Git** (for cloning dotfiles)
- **Nix** (primary package manager for CLI tools)

## Installation

### 1. Clone Dotfiles (Bare Repo)

```bash
# Clone as bare repository
git clone --bare git@github.com:darrensemusemu/dotfiles.git ~/.dotfiles.git

# Checkout files
git --git-dir=~/.dotfiles.git --work-tree=~ checkout git-bare-repo

# Optional: Add alias for convenience
alias dotfiles='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
```

### 2. Configure Git (Optional)

The `.gitconfig` file is tracked as a template. Customize for your machine:

```bash
# Default uses GitHub no-reply email (privacy-friendly)
# For work repos, uncomment and edit the includeIf section in ~/.gitconfig

# Example: Add work-specific config
vim ~/.gitconfig  # Uncomment and update work org URL pattern

# Create ~/.gitconfig-work for work email (optional)
cat > ~/.gitconfig-work << EOF
[user]
    email = your-work-email@example.com
EOF
```

### 3. Install Packages

#### macOS
```bash
# Install Nix packages (CLI tools)
~/.darren/nix/install.sh

# Install Homebrew casks (GUI apps - requires Homebrew)
~/.darren/install-brew.sh
```

#### Linux (Arch)
```bash
# Install Nix packages (CLI tools + Ghostty)
~/.darren/nix/install.sh

# Install browsers via pacman (faster security updates)
# Edit ~/.darren/packages.pacman.txt and uncomment browsers you want
sudo pacman -S firefox chromium
```

## Package Management Strategy

| Package Type | macOS | Linux (Arch) |
|--------------|-------|--------------|
| **CLI Tools** | Nix | Nix |
| **Browsers** | Homebrew | Pacman |
| **Ghostty** | Homebrew | Nix |
| **System Packages** | N/A | Pacman |

### Why This Split?

- **Nix**: Cross-platform CLI tools, reproducible environments
- **Homebrew**: macOS-native GUI applications (.app bundles)
- **Pacman**: Faster security updates for browsers on Arch

## Package Files

- `nix/packages.nix` - Declarative Nix packages (cross-platform CLI tools)
- `packages.brew.txt` - Homebrew casks (macOS GUI apps)
- `packages.pacman.txt` - Arch packages (browsers + system packages)

## Updating

```bash
# Update Nix packages
nix-channel --update
~/.darren/nix/install.sh

# Update Homebrew casks (macOS)
brew upgrade --cask

# Update Arch packages
sudo pacman -Syu
```

## Rollbacks

Nix supports generation rollbacks:

```bash
# List generations
nix-env --list-generations

# Rollback to previous
nix-env --rollback

# Switch to specific generation
nix-env --switch-generation 5

# Clean up old generations
nix-collect-garbage -d
```
