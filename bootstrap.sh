#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.config-backups/configs-$(date +%Y%m%d-%H%M%S)"
INCLUDE_NVIM=0

BREW_BIN="/opt/homebrew/bin/brew"
BREW_PACKAGES=(
  fish
  pyenv
  pyenv-virtualenv
  nvm
)

install_homebrew() {
  if [[ -x "$BREW_BIN" ]]; then
    return
  fi

  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew_shellenv() {
  if [[ -x "$BREW_BIN" ]]; then
    eval "$("$BREW_BIN" shellenv)"
  fi
}

install_packages() {
  ensure_brew_shellenv

  echo "Installing packages: ${BREW_PACKAGES[*]}"
  "$BREW_BIN" install "${BREW_PACKAGES[@]}"

  mkdir -p "$HOME/.nvm"
}

install_item() {
  local rel_path="$1"
  local src="$REPO_ROOT/$rel_path"
  local dest="$HOME/$rel_path"

  if [[ ! -e "$src" ]]; then
    echo "Skipping missing source: $rel_path"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_ROOT/$(dirname "$rel_path")"
    mv "$dest" "$BACKUP_ROOT/$rel_path"
    echo "Backed up $rel_path -> $BACKUP_ROOT/$rel_path"
  fi

  if [[ -d "$src" ]]; then
    cp -R "$src" "$dest"
  else
    cp "$src" "$dest"
  fi

  echo "Installed $rel_path"
}

ITEMS=(
  ".zshrc"
  ".zprofile"
  ".zsh/completions"
  ".config/fish/config.fish"
  ".config/fish/completions"
  ".config/fish/functions"
)

usage() {
  cat <<EOF
Usage: ./bootstrap.sh [--with-nvim]

Installs Homebrew, shell dependencies, and shell config files.
Pass --with-nvim to also install Neovim config files.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-nvim)
      INCLUDE_NVIM=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$INCLUDE_NVIM" -eq 1 ]]; then
  ITEMS+=(".config/nvim")
fi

for item in "${ITEMS[@]}"; do
  install_item "$item"
done

install_homebrew
install_packages

echo ""
echo "Bootstrap complete."
echo "If needed, create local secret files from:"
echo "  - $REPO_ROOT/.zshrc.local.example -> ~/.zshrc.local"
echo "  - $REPO_ROOT/.config/fish/config.local.fish.example -> ~/.config/fish/config.local.fish"
