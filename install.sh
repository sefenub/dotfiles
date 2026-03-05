#!/usr/bin/env bash
set -euo pipefail

# Cleaned up duplicates and added terraform to the main list
APT_PACKAGES=(
  git curl neovim htop build-essential unzip
  tmux podman xclip google-cloud-cli terraform
)

# Helper to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

apt_prep() {
  echo "--- Preparing APT Repositories ---"
  sudo apt-get update -y
  sudo apt-get install -y ca-certificates gnupg curl software-properties-common

  # 1. Terraform
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  fi
  if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  fi

  # 2. Neovim PPA
  if ! grep -q "neovim-ppa" /etc/apt/sources.list.d/* 2>/dev/null; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
  fi

  # 3. Google Cloud CLI
  if [ ! -f /usr/share/keyrings/cloud.google.gpg ]; then
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  fi
  if [ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
  fi
}

install_apt_packages() {
  echo "--- Installing APT Packages ---"
  sudo apt-get update -y
  sudo apt-get install -y "${APT_PACKAGES[@]}"
}

install_jsstuff() {
  echo "--- Installing JS Environment ---"

  # 1. FNM Install
  if ! command_exists fnm; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fi

  # 2. Load FNM into current session
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd)"

  # 3. Handle Node LTS
  echo "Ensuring Node LTS is installed and active..."
  fnm install --lts

  # 'fnm use' needs the alias name, not the flag
  fnm use lts-latest || fnm default lts-latest

  # 4. PNPM
  if ! command_exists pnpm; then
    echo "Installing pnpm..."
    npm install -g pnpm
  fi

  # 5. Bun
  if [ ! -d "$HOME/.bun" ]; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
  fi
}

install_starship() {
  if ! command_exists starship; then
    echo "--- Installing Starship ---"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
}

install_uv() {
  if ! command_exists uv; then
    echo "--- Installing UV ---"
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
}

install_k8s() {
  if ! command_exists kubectl; then
    echo "--- Installing Kubectl ---"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
  fi
}

# These are often wrapper scripts; check if binary exists in local bin
install_ai_tools() {
  echo "--- Installing AI Tools ---"
  if ! command_exists claude; then
    curl -fsSL https://claude.ai/install.sh | bash || echo "Claude install failed or already present"
  fi
  if ! command_exists opencode; then
    curl -fsSL https://opencode.ai/install | bash || echo "Opencode install failed"
  fi
}

main() {
  apt_prep
  install_apt_packages
  install_jsstuff
  install_ai_tools
  install_starship
  install_uv
  install_k8s
  
  echo "--- Setup Complete! Please restart your shell. ---"
}

main
