#!/bin/bash
# generate_routes_index.sh
# Run this from inside the Routes/ folder.
# 1. Scans subfolders and writes routes_index.json (for the sidebar).
# 2. Inside each subfolder, finds the .gpx file and writes route_info.json
#    (so GitHub Pages can find the GPX without a directory listing).

# Find all immediate subfolders, sorted alphabetically
folders=()
while IFS= read -r -d '' dir; do
    folders+=("$(basename "$dir")")
done < <(find . -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

if [ ${#folders[@]} -eq 0 ]; then
    echo "No subfolders found. Nothing written."
    exit 1
fi

# ── 1. Write routes_index.json ──────────────────────────────
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
echo ""

# ── 2. Write route_info.json in each subfolder ───────────────
for folder in "${folders[@]}"; do
    gpx_file=$(find "$folder" -maxdepth 1 -name "*.gpx" | head -1)
    if [ -z "$gpx_file" ]; then
        echo "  WARNING: No .gpx found in $folder — skipping route_info.json"
        continue
    fi
    gpx_name=$(basename "$gpx_file")
    echo "{\"gpx\": \"$gpx_name\"}" > "$folder/route_info.json"
    echo "  Written $folder/route_info.json  (gpx: $gpx_name)"
done

echo ""
echo "Done."
