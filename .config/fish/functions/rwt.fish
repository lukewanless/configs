function rwt --description "Remove a worktree using deploy/remove_worktree.sh"
    if test "$argv[1]" = "--complete"
        __wt_complete_worktree_branches
        return
    end

    if test (count $argv) -ne 1
        echo "Usage: rwt <branch-name-or-worktree-path>"
        return 1
    end

    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "rwt: run this inside a repository worktree"
        return 1
    end

    command "$repo/deploy/remove_worktree.sh" "$argv[1]"
end
