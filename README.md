# Install nvim

```
sudo apt install unzip ripgrep build-essential
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

# Install node

```
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install node
```

# Install python

```
sudo apt install python3-venv
```

```
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make && cd -
```
