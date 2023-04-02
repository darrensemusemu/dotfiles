#!/usr/bin/env bash

set -e
set -o errtrace

trap cleanup EXIT

cleanup() {
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

syslink_srcdir() {
	cd src &>/dev/null
	rm -rf ../log_syslinks.txt

	for file_name in .[!.]* *; do
		file_path="$HOME/$file_name"
		if [[ -e "$file_path" ]]; then
			mkdir -p "$HOME/.dotfiles.old"
			echo "[INFO]: file exists '$file_name', renaming to ~/.dotfiles.old/$file_name"
			rm -rf "$HOME/.dotfiles.old/$file_name"
			mv "$file_path" "$HOME/.dotfiles.old/$file_name"
		fi

		file_path_curr="$(pwd)/$file_name"
		ln -sf $file_path_curr "$HOME/$file_name"
		echo $file_path_curr >>../log_syslinks.txt
	done

	cd - &>/dev/null
}

git submodule update --init --recursive >log_installation.txt

syslink_srcdir

exit 0
