# Neovim Tools

The Neovim setup in `.config/nvim` uses `lazy.nvim` and installs plugins from `lazy-lock.json`.

## Required CLI tools

- `git` (plugin installs/updates)
- `nvim` (version 0.9+ recommended)
- `make` (for `telescope-fzf-native.nvim`)

## Recommended CLI tools

- `ripgrep` (`rg`) for fast project text search with Telescope
- `fd` (`fd-find`) for fast file discovery with Telescope
- `python3` and `node` for some Treesitter/LSP workflows

## LSP and language tooling

- `mason.nvim` + `mason-lspconfig.nvim` are configured to ensure `lua_ls` is installed.
- Treesitter parsers are configured for: `lua`, `vim`, `vimdoc`, `javascript`, `typescript`, `python`.
