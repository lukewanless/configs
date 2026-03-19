# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias python='python3'
alias nv='nvim'
alias gs='git status'
alias gaa='git add .'
alias gcv='git commit -v'
alias gp='git push'
alias pip='pip3'
alias fs='fish'
alias gwl='git worktree list'

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
