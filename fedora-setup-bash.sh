#!/usr/bin/env bash

set -eu pipefail

cd $HOME

# git
sudo dnf install -y git

git clone https://github.com/NDari/new-dots.git $HOME/dotfiles

# git conf
git config --global init.defaultbranch "main"
git config --global core.whitespace "cr-at-eol"
git config --global include.path $HOME/dotfiles/delta/delta.conf

# bash
cd $HOME
mv .bashrc .bashrc.bak
ln -s $HOME/dotfiles/bash/bashrc $HOME/.bashrc

# oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# nvim
cd $HOME
mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/nvim/init.lua $HOME/.config/nvim/init.lua
ln -s $HOME/dotfiles/nvim/minimal-nvim.lua $HOME/.config/nvim/minimal-nvim.lua

# ssh
mkdir $HOME/.ssh
if [[ -f /mnt/c/Users/nasee/.ssh/id_ed25519 ]]
then
	cp /mnt/c/Users/nasee/.ssh/id_ed25519 $HOME/.ssh/
	chmod 600 $HOME/.ssh/id_ed25519
fi
if [[ -f /mnt/c/Users/nasee/.ssh/id_ed25519.pub ]]
then
	cp /mnt/c/Users/nasee/.ssh/id_ed25519.pub $HOME/.ssh/
fi

sudo dnf install -y \
	fzf \
	neovim \
	direnv \
	tmux \
	xclip \
	openssl-devel \
	ripgrep \
	fd-find \
	just \
	git-delta \
	zoxide \
	bat \
	procs \
	tealdeer \
	uv

# tmux
cd $HOME
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/bin/install_plugins

# go
GO_VERSION="go1.24.4"
mkdir -p $HOME/tools && cd $HOME/tools
curl -LO https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz
rm ${GO_VERSION}.linux-amd64.tar.gz
cd $HOME

# to remove windows $PATH from infecting this path in WSL
# will need to shut down and restart (wsl --shutdown)
if [[ -f /etc/wsl.conf ]]
then
	sudo bash -c "cat <<EOF>> /etc/wsl.conf

[interop]
appendWindowsPath = false
EOF
"
fi
