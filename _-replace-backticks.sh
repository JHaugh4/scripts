#!/usr/bin/env bash
# Exit on error
set -e

# ==============================================================================
# Script Name: replace_backticks.sh
# Description: Scans an input file for text between backticks `...`, passes that 
#              text to an external script, and replaces the backticked section 
#              with the output of that script.
# Usage:       ./replace_backticks.sh <input_file> <runner_script> <output_file>
# ==============================================================================

INPUT_FILE="$1"
RUNNER_SCRIPT="$2"
OUTPUT_FILE="$3"

# --- Error Checking ---

if [[ -z "$INPUT_FILE" || -z "$RUNNER_SCRIPT" || -z "$OUTPUT_FILE" ]]; then
    echo "Error: Missing arguments."
    echo "Usage: $0 <input_file> <runner_script> <output_file>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

if [[ ! -f "$RUNNER_SCRIPT" ]]; then
    echo "Error: Runner script '$RUNNER_SCRIPT' not found."
    exit 1
fi

# Check if the output file exists
if [[ -f "$OUTPUT_FILE" ]]; then
    echo "$OUTPUT_FILE already exists!"
    exit 1
fi

# Ensure the runner script is executable
if [[ ! -x "$RUNNER_SCRIPT" ]]; then
    echo "Warning: '$RUNNER_SCRIPT' is not executable. Attempting to chmod..."
    chmod +x "$RUNNER_SCRIPT"
fi

# Export the runner script path so Perl can see it safely
export RUNNER_ENV="$RUNNER_SCRIPT"

# --- Processing ---

# We use chr(39) to generate the single quote character inside Perl.
# This prevents conflicts with the Bash shell quotes wrapping the command.

perl -0777 -pe '
    BEGIN { $q = chr(39); }

    s/`([^`]+)`/
      $arg = $1;
      $cmd = $ENV{RUNNER_ENV};
      
      $arg =~ s!$q!$q\\$q$q!g;
      
      $full_cmd = "$cmd $q$arg$q";
      $output = qx($full_cmd);

      $output =~ s^\s+$^^g;
      $output =~ s^\s+^^g;

      "`" . $output . "`"
    /ge
' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Success! Processed file saved to: $OUTPUT_FILE"