function swt --description "Switch to a worktree by branch"
    if test "$argv[1]" = "--complete"
        __wt_complete_worktree_branches
        return
    end

    if test (count $argv) -ne 1
        echo "Usage: swt <branch>"
        return 1
    end

    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "swt: run this inside a repository worktree"
        return 1
    end

    set -l target (__wt_worktree_path "$repo" "$argv[1]")
    if test -z "$target"
        echo "swt: no worktree found for branch '$argv[1]'"
        return 1
    end

    cd "$target"
end
