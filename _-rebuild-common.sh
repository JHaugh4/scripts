machines=(laptop desktop)

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
