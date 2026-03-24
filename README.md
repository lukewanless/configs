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

`bootstrap.sh`:

- installs Homebrew if needed
- installs shell dependencies used by these configs: `fish`, `pyenv`, `pyenv-virtualenv`, and `nvm`
- installs zsh and fish config files
- creates `~/.nvm`
- backs up existing files into `~/.config-backups/configs-<timestamp>/` before installing

To also install Neovim config files:

```bash
./bootstrap.sh --with-nvim
```

After bootstrap finishes, restart your shell or run:

```bash
source ~/.zprofile
source ~/.zshrc
```

For `nvm`, this repo uses the Homebrew-managed installation path:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
```

Homebrew notes that `nvm` via Homebrew is unsupported by upstream. If you hit `nvm` issues, check them against the standard `nvm` install method before reporting them upstream.

## Local secrets

Secrets are intentionally not committed.

```bash
cp .zshrc.local.example ~/.zshrc.local
cp .config/fish/config.local.fish.example ~/.config/fish/config.local.fish
```

Then set your real values in those local files (for example `XAI_API_KEY`).

## Fish command memory transfer

Fish history and universal variables are machine state and are intentionally not committed.

Export from your current machine:

```bash
./scripts/export-fish-state.sh
```

Or export to a specific folder:

```bash
./scripts/export-fish-state.sh ~/Desktop/fish-state
```

Import on the new machine:

```bash
./scripts/import-fish-state.sh ~/Desktop/fish-state
```

`import-fish-state.sh` backs up your current Fish state to `~/.config-backups/fish-state-import-<timestamp>/` first.

## Neovim tools

See [docs/nvim-tools.md](docs/nvim-tools.md) for required and recommended CLI dependencies.

## PR Notes

- Extracted current configs from local machine into original path layout.
- Removed committed secrets and replaced with local `.example` templates.
- Added portable shell config behavior (`$HOME` paths and local override sourcing).
- Added `bootstrap.sh` for repeatable setup on new Macs with automatic backups.
