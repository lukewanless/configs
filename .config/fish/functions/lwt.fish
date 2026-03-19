function lwt --description "List worktrees"
    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "lwt: run this inside a repository worktree"
        return 1
    end

    command git -C "$repo" worktree list
end
