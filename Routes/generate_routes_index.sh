#!/bin/bash
# generate_routes_index.sh
# Run this from inside the Routes/ folder.
# Scans for subfolders and writes routes_index.json.

# Find all immediate subfolders, sorted alphabetically
folders=()
while IFS= read -r -d '' dir; do
    folders+=("$(basename "$dir")")
done < <(find . -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

if [ ${#folders[@]} -eq 0 ]; then
    echo "No subfolders found. Nothing written."
    exit 1
fi

# Build JSON array
json="["
for i in "${!folders[@]}"; do
    if [ $i -gt 0 ]; then
        json+=", "
    fi
    json+="\"${folders[$i]}\""
done
json+="]"

echo "$json" > routes_index.json
echo "Written routes_index.json:"
echo "$json"
