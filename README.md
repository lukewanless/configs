# Mac Configs

This repo tracks shell and Neovim configs in original path layout so they can be installed directly on a new Mac.

## Tracked paths

- `.zshrc`
- `.zprofile`
- `.zsh/completions/_openspec`
- `.config/fish/config.fish`
- `.config/fish/functions/*.fish`
- `.config/fish/completions/*.fish`
- `.config/nvim/init.lua`
- `.config/nvim/lazy-lock.json`

## Install on a new Mac

```bash
git clone <this-repo-url>
cd configs
./bootstrap.sh
```

`bootstrap.sh` backs up existing files into `~/.config-backups/configs-<timestamp>/` before installing.

## Local secrets

Secrets are intentionally not committed.

```bash
cp .zshrc.local.example ~/.zshrc.local
cp .config/fish/config.local.fish.example ~/.config/fish/config.local.fish
```

Then set your real values in those local files (for example `XAI_API_KEY`).

## Neovim tools

See [docs/nvim-tools.md](docs/nvim-tools.md) for required and recommended CLI dependencies.

## PR Notes

- Extracted current configs from local machine into original path layout.
- Removed committed secrets and replaced with local `.example` templates.
- Added portable shell config behavior (`$HOME` paths and local override sourcing).
- Added `bootstrap.sh` for repeatable setup on new Macs with automatic backups.
