#!bin/bash
sudo apt install -y unzip ripgrep build-essential python3-venv
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
echo PATH="\$PATH:/opt/nvim-linux-x86_64/bin"
source .bashrc

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source .bashrc
nvm install node
