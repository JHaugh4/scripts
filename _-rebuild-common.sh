machines=(laptop desktop)
nixos_dir=/etc/nixos

check_repo_sync() {
    local repo="${1:-$nixos_dir}"
    echo "Checking repo sync: $repo" >&2

    if ! git -C "$repo" fetch --quiet 2>/dev/null; then
        echo "Warning: could not reach remote, skipping sync check" >&2
        return 0
    fi

    local local_sha remote_sha
    local_sha=$(git -C "$repo" rev-parse HEAD)
    remote_sha=$(git -C "$repo" rev-parse '@{u}' 2>/dev/null) || {
        echo "Warning: no upstream tracking branch configured, skipping sync check" >&2
        return 0
    }

    if [[ "$local_sha" == "$remote_sha" ]]; then
        return 0
    fi

    local behind ahead
    behind=$(git -C "$repo" rev-list --count HEAD.."$remote_sha")
    ahead=$(git -C "$repo" rev-list --count "$remote_sha"..HEAD)

    if (( behind > 0 )); then
        echo "Error: local repo is $behind commit(s) behind remote. Run 'git -C $repo pull' first." >&2
        exit 1
    fi

    if (( ahead > 0 )); then
        echo "Warning: local repo is $ahead commit(s) ahead of remote (not yet pushed)." >&2
    fi
}

pick_machine() {
    echo "Select a machine:" >&2
    for i in "${!machines[@]}"; do
        echo "  $i) ${machines[$i]}" >&2
    done
    printf "Enter number: " >&2
    read -r choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice >= ${#machines[@]} )); then
        echo "Invalid selection" >&2
        exit 1
    fi
    echo "${machines[$choice]}"
}
