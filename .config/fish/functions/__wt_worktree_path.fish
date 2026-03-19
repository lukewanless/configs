function __wt_worktree_path --description "Resolve worktree path for a branch"
    set -l repo "$argv[1]"
    set -l branch "$argv[2]"

    command git -C "$repo" worktree list --porcelain \
    | awk -v b="refs/heads/$branch" '
        $1=="worktree" { path=$2 }
        $1=="branch" && $2==b { print path; exit }
    '
end
