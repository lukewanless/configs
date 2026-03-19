function cwt --description "Create a worktree using deploy/setup_worktree.sh"
    if test "$argv[1]" = "--complete"
        __wt_complete_worktree_branches
        return
    end

    if test (count $argv) -lt 1
        echo "Usage: cwt <branch-name> [base-ref]"
        return 1
    end

    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "cwt: run this inside a repository worktree"
        return 1
    end

    command "$repo/deploy/setup_worktree.sh" $argv
end
