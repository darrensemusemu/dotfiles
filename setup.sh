#!/usr/bin/env bash

set -e

export HOMEBREW_NO_AUTO_UPDATE=1

platform="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
	platform="macos"
elif [[ $"$OSTPYE" == "linux-gnu"* ]]; then
	platform="linux"
else
	echo "[FAIL]: Unsupprted/unknown platform" >&2
	exit -1
fi

# Checks if program and install the programmig
package_exists() {
	if ! command -v $1 &>/dev/null; then
		echo "[INFO]: '$1' not found, installing..."
		return 1
	else
		echo "[INFO]: '$1' already installed, continuing..."
		return 0
	fi
}

packages_macos=()
packages_macos[0]="common::brew install zsh ctags tree"
packages_macos[1]="iterm2::brew install --cask iterm2 --force"

packages_install() {
	echo "[INFO]: installing brew"
	arr=("$@")
	for i in "${arr[@]}"; do
		key="${i%::*}"
		val="${i##*::}"
		echo "[INFO]: Instaling '$key' w/ '$val' ....'"
		command $val #&> /dev/null
	done
}

if [[ "$platform" == "macos" ]]; then
	packages_install "${packages_macos[@]}"
elif [[ "$platform" == "macos" ]]; then
	echo "[FAIL]: platform not yet implemented/supported"
fi

if ! package_exists "omz"; then
	rm -rf /Users/darrensemusemu/.oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
