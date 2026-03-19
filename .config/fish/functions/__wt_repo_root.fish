function __wt_repo_root --description "Resolve current repo root for worktree helpers"
    set -l repo (command git rev-parse --show-toplevel 2>/dev/null)
    or return 1

    if not test -f "$repo/deploy/setup_worktree.sh"
        return 1
    end

    echo "$repo"
end
