#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-$HOME/.config-backups/fish-state-$(date +%Y%m%d-%H%M%S)}"
HISTORY_SRC="$HOME/.local/share/fish/fish_history"
VARIABLES_SRC="$HOME/.config/fish/fish_variables"

mkdir -p "$OUT_DIR"

if [[ -f "$HISTORY_SRC" ]]; then
  cp "$HISTORY_SRC" "$OUT_DIR/fish_history"
  chmod 600 "$OUT_DIR/fish_history"
  echo "Exported history -> $OUT_DIR/fish_history"
else
  echo "No fish_history found at $HISTORY_SRC"
fi

if [[ -f "$VARIABLES_SRC" ]]; then
  cp "$VARIABLES_SRC" "$OUT_DIR/fish_variables"
  chmod 600 "$OUT_DIR/fish_variables"
  echo "Exported universal vars -> $OUT_DIR/fish_variables"
else
  echo "No fish_variables found at $VARIABLES_SRC"
fi

echo "Export complete: $OUT_DIR"
echo "Transfer this directory privately to your new machine."
