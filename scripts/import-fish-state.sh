#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <export-dir>"
  echo "Example: $0 ~/Downloads/fish-state-20260319-150000"
  exit 1
fi

IN_DIR="$1"
HISTORY_IN="$IN_DIR/fish_history"
VARIABLES_IN="$IN_DIR/fish_variables"
HISTORY_DEST="$HOME/.local/share/fish/fish_history"
VARIABLES_DEST="$HOME/.config/fish/fish_variables"
BACKUP_ROOT="$HOME/.config-backups/fish-state-import-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_ROOT" "$(dirname "$HISTORY_DEST")" "$(dirname "$VARIABLES_DEST")"

if [[ -f "$HISTORY_DEST" ]]; then
  cp "$HISTORY_DEST" "$BACKUP_ROOT/fish_history"
  chmod 600 "$BACKUP_ROOT/fish_history"
  echo "Backed up current history -> $BACKUP_ROOT/fish_history"
fi

if [[ -f "$VARIABLES_DEST" ]]; then
  cp "$VARIABLES_DEST" "$BACKUP_ROOT/fish_variables"
  chmod 600 "$BACKUP_ROOT/fish_variables"
  echo "Backed up current universal vars -> $BACKUP_ROOT/fish_variables"
fi

if [[ -f "$HISTORY_IN" ]]; then
  cp "$HISTORY_IN" "$HISTORY_DEST"
  chmod 600 "$HISTORY_DEST"
  echo "Imported history -> $HISTORY_DEST"
else
  echo "Missing input file: $HISTORY_IN"
fi

if [[ -f "$VARIABLES_IN" ]]; then
  cp "$VARIABLES_IN" "$VARIABLES_DEST"
  chmod 600 "$VARIABLES_DEST"
  echo "Imported universal vars -> $VARIABLES_DEST"
else
  echo "Missing input file: $VARIABLES_IN"
fi

echo "Import complete."
echo "Restart Fish (or run: exec fish -l) to load imported state."
