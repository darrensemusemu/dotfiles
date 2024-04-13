# dotfiles

Personal Working setup

## Prerequisites

Following need to neeed to be installed on system:

- omymyzsh

- Tmux

- Vim / NVIM

## setup

Based off: https://www.atlassian.com/git/tutorials/dotfiles

Clone repo
```sh
echo ".dotfiles.git" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles.git
```

Add following to your  path:
```sh
alias cfg='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
```

Use `cfg to add / remove / pull` e.g.
```sh
cfg add .vim/vimrc
cfg commit -m "vimrc: setup lightline"
```






## Additinal Setup

- Addtional Linux specific setup: TODO

- Additional Extra MacOS specific setup: TODO



