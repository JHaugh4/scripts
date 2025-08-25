#!/usr/bin/env bash
# Exit on error
set -e

#!/bin/bash

# This script takes a single string as an argument and first escapes
# any special regex characters. It then inserts "\s*" before and after
# every character in the sanitized string.

# Check if an argument was provided.
if [ -z "$1" ]; then
    echo "Error: No input string provided."
    echo "Usage: $0 \"your input string here\""
    exit 1
fi

# Store the input string in a variable.
input_string="$1"

# Escape special regex characters in the input string.
# We use 'sed' to replace each special character with a backslash followed by the character itself.
# Special characters handled: . ( ) [ ] { } * + ? ^ $ | \
# We use a character set `[...]` to match any of the special characters.
# The double backslash `\\` is necessary to produce a single literal backslash in the output.
# The `&` in the replacement string refers to the entire matched pattern (i.e., the special character).
escaped_string=$(echo "$input_string" | sed 's/[][(){}.*+?|^$]/\\&/g')

# Initialize the output string with "\s*".
# This handles the insertion before the first character.
output_string="\s*"

# Get the length of the escaped string.
string_length=${#escaped_string}

# Loop through each character of the escaped string.
for (( i=0; i<string_length; i++ )); do
    # Extract the character at the current position.
    char="${escaped_string:i:1}"

    # Don't splice in after \
    if [[ "$char" == "\\" ]]; then
        # Just append the char
        output_string+="$char"
    else
        # Append the character and "\s*" to the output string.
        output_string+="$char\s*"
    fi
done

# Print the original and modified strings.
echo "$output_string"
echo -n "$output_string" | wl-copy
echo "Copied to clipboard!"
