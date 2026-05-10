machines=(laptop desktop)

pick_machine() {
    echo "Select a machine:"
    for i in "${!machines[@]}"; do
        echo "  $i) ${machines[$i]}"
    done
    printf "Enter number: "
    read -r choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice >= ${#machines[@]} )); then
        echo "Invalid selection" >&2
        exit 1
    fi
    echo "${machines[$choice]}"
}
