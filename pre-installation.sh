#!/usr/bin/env bash

# Exit immediately on error
set -e

# Update package list and install dependencies
sudo apt update
sudo apt install -y unzip ripgrep build-essential python3-venv curl wget xclip fd-find tmux

# Neovim uses xclip when SSH provides a forwarded DISPLAY and falls back to its
# built-in OSC 52 provider otherwise. A server-side X server/Xvfb is not needed.

# Allow applications inside tmux (including Neovim) to forward OSC 52
# clipboard writes to a compatible terminal on the SSH client.
if ! grep -q '^set -g set-clipboard on$' ~/.tmux.conf 2>/dev/null; then
  printf '\n# Forward application clipboard writes to the client terminal.\nset -g set-clipboard on\n' >> ~/.tmux.conf
fi

# Apply the setting to an already-running tmux server when there is one.
tmux source-file ~/.tmux.conf 2>/dev/null || true

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
nvm install --lts
nvm use --lts

npm i -g yarn
