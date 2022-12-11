# Dotfiles

Quick setup for my working environment.

## Prerequisites

- Homebrew: install `brew` to continue with setup

- Vim 8+: update to at least vim 8+

Linux

- Not yet implemented/supported

## Quick Start

Existing files are moved to `$HOME/.dotfiles.old` to avoid rewrite.

```bash
./setup.sh
```

Change default shell

```bash
zsh && chsh -s $(which zsh)
```

## TODO

- [ ] Prompt what packages to install, currently installs/updates all
- [ ] Install Linux dependencies, currently on setups MacOS environment
