function dwt --description "Delete local-only worktree branch and its worktree"
    if test "$argv[1]" = "--complete"
        __wt_complete_worktree_branches
        return
    end

    if test (count $argv) -ne 1
        echo "Usage: dwt <branch>"
        return 1
    end

    set -l branch "$argv[1]"
    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "dwt: run this inside a repository worktree"
        return 1
    end

    if not command git -C "$repo" show-ref --verify --quiet "refs/heads/$branch"
        echo "dwt: local branch '$branch' does not exist"
        return 1
    end

    set -l target (__wt_worktree_path "$repo" "$branch")
    if test -z "$target"
        echo "dwt: no worktree found for branch '$branch'"
        return 1
    end

    if test "$target" = "$repo"
        echo "dwt: refusing to delete the main repository worktree"
        return 1
    end

    set -l remote_ref (command git -C "$repo" for-each-ref --format='%(refname)' "refs/remotes/*/$branch")
    if test -n "$remote_ref"
        echo "dwt: '$branch' has a remote branch; refusing to delete"
        return 1
    end

    command "$repo/deploy/remove_worktree.sh" "$branch"
    or return $status

    command git -C "$repo" branch -D "$branch"
end
