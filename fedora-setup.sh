#!/usr/bin/env bash

set -eu pipefail

cd $HOME

# git
sudo dnf install -y git

git clone https://github.com/NDari/new-dots.git $HOME/dotfiles

# git conf
git config --global user.email "naseerdari01@gmail.com"
git config --global user.name "Naseer Dari"
git config --global init.defaultbranch "main"
git config --global core.whitespace "cr-at-eol"
git config --global include.path $HOME/dotfiles/delta/delta.conf

# zsh
cd $HOME
sudo dnf install -y zsh
chsh -s /usr/bin/zsh
ln -s $HOME/dotfiles/zsh/zshrc $HOME/.zshrc

# zinit
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# nvim
cd $HOME
# regular nvim
mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/nvim/init.lua $HOME/.config/nvim/init.lua
ln -s $HOME/dotfiles/nvim/lua $HOME/.config/nvim/lua
# minimal nvim, does not install plugins
mkdir -p $HOME/.config/minvim
# copy the init since we will change it.
cp $HOME/dotfiles/nvim/init.lua $HOME/.config/minvim/init.lua
ln -s $HOME/dotfiles/nvim/lua $HOME/.config/minvim/lua
# disable plugins
sed -i 's/local add_plugins = true/local add_plugins = false/' $HOME/.config/minvim/init.lua

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
	uv

# tmux
cd $HOME
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/bin/install_plugins

# go
mkdir -p $HOME/tools && cd $HOME/tools
curl -LO https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
rm go1.24.3.linux-amd64.tar.gz
cd $HOME

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
$HOME/.cargo/bin/cargo install cargo-update
$HOME/.cargo/bin/cargo install du-dust
$HOME/.cargo/bin/cargo install just
$HOME/.cargo/bin/cargo install fd-find
$HOME/.cargo/bin/cargo install ripgrep
$HOME/.cargo/bin/cargo install bat
$HOME/.cargo/bin/cargo install zoxide
$HOME/.cargo/bin/cargo install procs
$HOME/.cargo/bin/cargo install tealdeer

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
