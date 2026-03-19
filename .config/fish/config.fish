if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias python='python3'
alias nv='nvim'
alias gs='git status'
alias gaa='git add .'
alias gcv='git commit -v'
alias gp='git push'
alias pip='pip3'
alias gwl='git worktree list'

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
