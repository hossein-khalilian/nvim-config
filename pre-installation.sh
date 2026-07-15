#!/usr/bin/env bash

# Exit immediately on error
set -e

# Update package list and install dependencies
sudo apt update
sudo apt install -y \
  unzip ripgrep build-essential python3-venv curl wget xclip fd-find tmux \
  openssh-server xauth

# Neovim uses xclip with the DISPLAY provided by SSH X11 forwarding. Do not
# start Xvfb on the server: it would create a remote-only clipboard instead.

# Enable X11 forwarding for remote Neovim sessions. If IPv6 is disabled,
# constrain sshd to IPv4 so it can allocate its X11 proxy display socket.
configure_sshd_x11() {
  local config_dir=/etc/ssh/sshd_config.d
  local config_file="$config_dir/60-nvim-x11-forwarding.conf"
  local backup_file
  local had_config=false
  local temp_file

  temp_file=$(mktemp)
  backup_file=$(mktemp)
  trap 'rm -f "$temp_file" "$backup_file"' RETURN

  cat >"$temp_file" <<'EOF'
# Managed by the Neovim pre-installation script.
X11Forwarding yes
X11UseLocalhost yes
EOF

  if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6 2>/dev/null || echo 0)" = 1 ]; then
    cat >>"$temp_file" <<'EOF'
# Avoid "Failed to allocate internet-domain X11 display socket" when IPv6 is disabled.
AddressFamily inet
EOF
  fi

  sudo install -d -m 755 "$config_dir"
  if ! sudo test -f "$config_file" || ! sudo cmp -s "$temp_file" "$config_file"; then
    if sudo test -f "$config_file"; then
      sudo cat "$config_file" >"$backup_file"
      had_config=true
    fi
    sudo install -m 600 "$temp_file" "$config_file"

    # Minimal/local installations may not have started ssh.service yet, so its
    # systemd runtime directory might not exist when sshd validates the config.
    sudo install -d -o root -g root -m 755 /run/sshd

    if ! sudo sshd -t; then
      if [ "$had_config" = true ]; then
        sudo install -m 600 "$backup_file" "$config_file"
      else
        sudo rm -f "$config_file"
      fi
      echo "Invalid sshd configuration; restored the previous configuration" >&2
      return 1
    fi

    if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
      if sudo systemctl is-active --quiet ssh; then
        sudo systemctl reload ssh
      elif sudo systemctl is-active --quiet sshd; then
        sudo systemctl reload sshd
      else
        sudo systemctl enable --now ssh 2>/dev/null || sudo systemctl enable --now sshd
      fi
    else
      sudo service ssh restart 2>/dev/null || sudo service sshd restart
    fi
  fi
}

configure_sshd_x11

# Install Neovim. Pin to a specific release (matches the version the plugin
# stack is tested against) instead of "latest" so a future breaking release
# can't silently break the setup. Bump this when upgrading.
NVIM_VERSION="v0.12.4"
curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
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

echo "Neovim pre-installation finished successfully."
