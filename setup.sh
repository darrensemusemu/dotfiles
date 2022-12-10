#!/usr/bin/env bash

set -e
set -o errtrace

trap cleanup EXIT

cleanup () {
	exit_code=$?
	if [[ ${exit_code} > 0 ]]; then
		echo "[ERROR]: exited with code: $exit_code, inspect log.txt"
	else 
		echo "[INFO]: setup completed success"
	fi
}

platform="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
	platform="macos"
elif [[ $"$OSTPYE" == "linux-gnu"* ]]; then
	platform="linux"
else
	echo "[FAIL]: Unsupprted/unknown platform" >&2
	exit 1
fi

export HOMEBREW_NO_AUTO_UPDATE=1

packages_macos=()
packages_macos[0]="common-all::brew install clang-format ctags go yarn zsh tree tmux"
# packages_macos[1]="iterm2::brew install --cask iterm2 --force"

packages_linux=()

packages_other=()
packages_other[0]="nvm::./scripts/nvm.sh" # NVM - Node Version Manager
packages_other[1]="omz::./scripts/omz.sh" # Oh-My-ZSH
packages_other[2]="goimports::go install golang.org/x/tools/cmd/goimports@latest" # Goimports formatter
packages_other[3]="checkmake::go install github.com/mrtazz/checkmake/cmd/checkmake@latest" # Markdown linter
packages_other[4]="cspell::npm install -g cspell" # CSpell  'Grammar' checker

package_exists() {
	if ! command -v $1 &>/dev/null; then
		echo "[INFO]: '$1' not found, installing..."
		return 1
	else
		echo "[INFO]: '$1' already installed, continuing..."
		return 0
	fi
}

packages_install_cmd() {
	arr=("$@")
	for i in "${arr[@]}"; do
		key="${i%::*}"
		val="${i##*::}"
		echo "[INFO]: Instaling '$key' w/ '$val' ....'"
		if ! package_exists $key; then
			command $val > log_installation.txt
		fi
	done
}

packages_install() {
	if [[ "$platform" == "macos" ]]; then
		packages_install_cmd "${packages_macos[@]}"
		echo "macosisin"
	elif [[ "$platform" == "linux" ]]; then
		echo "[FAIL]: platform not yet implemented/supported"
	fi

	packages_install_cmd "${packages_other[@]}"
}

syslink_srcdir() {
	cd src &>/dev/null
	rm -rf ../log_syslinks.txt

	for file_name in .[!.]* *; do
		file_path="$HOME/.dotfiles/$file_name" 
		if [[ -e "$file_path" ]]; then 
			mkdir -p "$HOME/.dotfiles.old"
			echo "[INFO]: file exists '$file_name', renaming to ~/.dotfiles.old/$file_name"
			rm -rf "$HOME/.dotfiles.old/$file_name"
			mv "$file_path" "$HOME/.dotfiles.old/$file_name"
		fi

		file_path_curr="$(pwd)/$file_name" 
		ln -sf $file_path_curr "$HOME/$file_name" 
		echo $file_path_curr >> ../log_syslinks.txt
	done

	cd - &>/dev/null
}

packages_install

syslink_srcdir

exit 0
