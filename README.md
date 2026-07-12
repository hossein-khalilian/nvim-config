# Install nvim

```
sudo apt install unzip ripgrep build-essential
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

## Clipboard over SSH

Remote Neovim sessions use a forwarded X11 display when available, allowing
`xclip` on the remote machine to update the local clipboard. Without a
forwarded `DISPLAY`, Neovim falls back to OSC 52; this requires a terminal that
supports OSC 52 clipboard writes.

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
