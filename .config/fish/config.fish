if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

if test -x /opt/homebrew/bin/pyenv
    pyenv init - fish | source
end

if test -d ~/.cargo/bin
    fish_add_path -m ~/.cargo/bin
end

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

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
