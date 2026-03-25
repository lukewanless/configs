if [[ -o interactive ]] && command -v fish >/dev/null 2>&1 && [[ -z "${FISH_VERSION:-}" ]]; then
  exec fish
fi

# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export PATH="$HOME/.cargo/bin:$PATH"

alias python='python3'
alias nv='nvim'
alias gs='git status'
alias gaa='git add .'
alias gcv='git commit -v'
alias gp='git push'
alias pip='pip3'
alias fs='fish'
alias gwl='git worktree list'
alias spt='spotatui'

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
