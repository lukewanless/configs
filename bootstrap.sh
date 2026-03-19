#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.config-backups/configs-$(date +%Y%m%d-%H%M%S)"

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
  ".config/nvim"
)

for item in "${ITEMS[@]}"; do
  install_item "$item"
done

echo ""
echo "Bootstrap complete."
echo "If needed, create local secret files from:"
echo "  - $REPO_ROOT/.zshrc.local.example -> ~/.zshrc.local"
echo "  - $REPO_ROOT/.config/fish/config.local.fish.example -> ~/.config/fish/config.local.fish"
