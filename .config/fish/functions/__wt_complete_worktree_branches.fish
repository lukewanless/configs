function __wt_complete_worktree_branches --description "List branch names attached to worktrees"
    set -l repo (__wt_repo_root)
    or return

    command git -C "$repo" worktree list --porcelain \
    | awk '/^branch refs\/heads\//{sub("^branch refs/heads/",""); print}'
end
