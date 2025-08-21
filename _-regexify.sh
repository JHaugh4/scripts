#!/usr/bin/env bash
# Exit on error
set -e

# This script takes a single string as an argument and inserts "\s*"
# before and after every character in the string.

# Check if an argument was provided.
if [ -z "$1" ]; then
    echo "Error: No input string provided."
    echo "Usage: $0 \"your input string here\""
    exit 1
fi

# Store the input string in a variable.
input_string="$1"

# Initialize the output string with "\s*".
# This handles the insertion before the first character.
output_string="\s*"

# Get the length of the input string.
string_length=${#input_string}

# Loop through each character of the input string.
for (( i=0; i<string_length; i++ )); do
    # Extract the character at the current position.
    char="${input_string:i:1}"
    
    # Append the character and "\s*" to the output string.
    output_string+="$char\s*"
done

# Print the original and modified strings.
echo "Original string: $input_string"
echo "Modified string: $output_string"
