#!/usr/bin/env bash

# Exit immediately on error
set -e

# Update package list and install dependencies
sudo apt update
sudo apt install -y unzip ripgrep build-essential python3-venv curl wget xclip fd-find

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo mkdir -p /opt/nvim
sudo tar -xzf nvim-linux-x86_64.tar.gz -C /opt/nvim --strip-components=1
rm nvim-linux-x86_64.tar.gz

# Add Neovim to PATH if not already added
if ! grep -q "/opt/nvim/bin" ~/.bashrc; then
  echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.bashrc
fi
source ~/.bashrc

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load NVM into current shell session
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest Node.js via NVM
nvm install node

npm i -g yarn
