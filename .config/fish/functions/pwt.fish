function pwt --description "Prune docker resources for a worktree"
    if test "$argv[1]" = "--complete"
        __wt_complete_worktree_branches
        return
    end

    if test (count $argv) -gt 1
        echo "Usage: pwt [branch-name]"
        return 1
    end

    set -l repo (__wt_repo_root)
    if test -z "$repo"
        echo "pwt: run this inside a repository worktree"
        return 1
    end

    if test (count $argv) -eq 0
        command "$repo/deploy/docker_prune_worktree.sh"
        return
    end

    set -l target (__wt_worktree_path "$repo" "$argv[1]")
    if test -z "$target"
        echo "pwt: no worktree found for branch '$argv[1]'"
        return 1
    end

    command "$target/deploy/docker_prune_worktree.sh"
end
