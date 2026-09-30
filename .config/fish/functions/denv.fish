function denv --description "List running docker environments: branch | compose project | containers"
    docker ps --format '{{.Label "com.docker.compose.project"}}\t{{.Label "com.docker.compose.project.working_dir"}}' | sort | uniq -c | while read -l count project dir
        set -l branch -
        if test -n "$dir"
            set branch (command git -C "$dir" branch --show-current 2>/dev/null)
            test -n "$branch"; or set branch -
        end
        test -n "$project"; or set project "(standalone)"
        printf '%s\t|\t%s\t|\t%s\n' $branch $project $count
    end | column -t -s \t
end
