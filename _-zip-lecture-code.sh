#!/usr/bin/env bash
# Exit on error
set -e

# Check if the number of arguments is not equal to 2
if [ "$#" -ne 2 ]; then
    echo "Error: Exactly 2 arguments required."
    echo "Usage: $0 <zip_name> <source_directory>"
    exit 1
fi

# Check if a directory path was provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/java/files"
    exit 1
fi

OUTPUT_ZIP="$1.zip"
SOURCE_DIR="$2"
TEMP_DIR="temp"

# Verify the provided directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' not found."
    exit 1
fi

# 1. Create temporary directory
mkdir -p "$TEMP_DIR"

echo "Processing .java files in $SOURCE_DIR..."

# 2. Loop through .java files in the target directory
# We use a nullglob to avoid errors if no .java files exist
shopt -s nullglob
for file in "$SOURCE_DIR"/*.java; do
    # Get just the filename without the path
    filename=$(basename "$file")

    # 3. Remove first two lines and save to temp
    tail -n +3 "$file" > "$TEMP_DIR/$filename"
    
    echo "  Processed: $filename"
done

# 4. Zip the files
if [ "$(ls -A "$TEMP_DIR")" ]; then
    echo "Zipping files into $OUTPUT_ZIP..."
    # -j ignores the temp directory structure inside the zip
    zip -j -q "$OUTPUT_ZIP" "$TEMP_DIR"/*
    echo "Done! Archive created: $OUTPUT_ZIP"
else
    echo "No .java files were found in '$SOURCE_DIR'."
fi

# 5. Cleanup
rm -rf "$TEMP_DIR"