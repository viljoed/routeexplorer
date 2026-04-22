#!/bin/bash
# generate_routes_index.sh
# Run this from inside the Routes/ folder.
#
# 1. Groups subfolders by their first 3 characters (case-insensitive).
#    Each group produces a <prefix>_index.json  e.g. adv_index.json
#    Folders whose 3-char prefix is unique (no siblings) are collected
#    into demo_index.json as a catch-all.
# 2. Inside each subfolder, finds the .gpx file and writes route_info.json
#    (so GitHub Pages can find the GPX without a directory listing).
#
# URL usage:
#   index.html              → Routes/demo_index.json
#   index.html?routes=adv   → Routes/adv_index.json

# ── Collect all immediate subfolders ────────────────────────
folders=()
while IFS= read -r -d '' dir; do
    folders+=("$(basename "$dir")")
done < <(find . -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

if [ ${#folders[@]} -eq 0 ]; then
    echo "No subfolders found. Nothing written."
    exit 1
fi

# ── Count occurrences of each 3-char prefix ─────────────────
declare -A prefix_count
for folder in "${folders[@]}"; do
    prefix=$(echo "${folder:0:3}" | tr '[:upper:]' '[:lower:]')
    prefix_count[$prefix]=$(( ${prefix_count[$prefix]:-0} + 1 ))
done

# ── Group folders into collections ──────────────────────────
declare -A collections   # prefix -> space-separated list of folder names

for folder in "${folders[@]}"; do
    prefix=$(echo "${folder:0:3}" | tr '[:upper:]' '[:lower:]')
    if [ "${prefix_count[$prefix]}" -gt 1 ]; then
        key="$prefix"
    else
        key="demo"
    fi
    if [ -z "${collections[$key]}" ]; then
        collections[$key]="$folder"
    else
        collections[$key]="${collections[$key]}|$folder"
    fi
done

# ── Write one _index.json per collection ────────────────────
echo "Writing index files:"
for key in $(echo "${!collections[@]}" | tr ' ' '\n' | sort); do
    IFS='|' read -ra members <<< "${collections[$key]}"
    json="["
    for i in "${!members[@]}"; do
        [ $i -gt 0 ] && json+=", "
        json+="\"${members[$i]}\""
    done
    json+="]"
    outfile="${key}_index.json"
    echo "$json" > "$outfile"
    echo "  $outfile  →  $json"
done

echo ""

# ── Write route_info.json in each subfolder ─────────────────
echo "Writing route_info.json files:"
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
