#!/usr/bin/env bash

set -e

rm -rf ~/.oh-my-zsh # TODO: should probably check if folder exists
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
