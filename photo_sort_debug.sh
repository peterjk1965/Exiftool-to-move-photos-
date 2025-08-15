#!/bin/bash

#PREREQUISITES readme first.


photos_dir="/mnt/c/Users/peter/Dropbox/Pictures"
move_dir="/mnt/d/Dropbox/Pictures"


# 1. Convert HEIC to JPG
find "${photos_dir}" -type f -iname '*.heic' | while IFS= read -r heic_file; do
    jpg_file="${heic_file%.*}.jpg"
    if [ ! -f "$jpg_file" ]; then
        echo "Converting: $heic_file → $jpg_file"
        convert "$heic_file" "$jpg_file"
    else
        echo "Skipping: $jpg_file already exists."
    fi
done

# 2. Sort JPGs (your fallback date logic)
find "${photos_dir}" -type f -iname '*.jpg' | while IFS= read -r photo; do
    echo "Processing: $photo"

    # Try multiple date fields in order of preference
    photo_date=$(exiftool -s -s -s -DateTimeOriginal "$photo")
    if [ -z "$photo_date" ]; then
        photo_date=$(exiftool -s -s -s -CreateDate "$photo")
    fi
    if [ -z "$photo_date" ]; then
        photo_date=$(exiftool -s -s -s -ModifyDate "$photo")
    fi
    if [ -z "$photo_date" ]; then
        photo_date=$(exiftool -s -s -s -FileModifyDate "$photo")
    fi

    # Still nothing? Skip file
    if [ -z "$photo_date" ]; then
        echo "  Skipping: No usable date found."
        continue
    fi

    # Extract year, month, day (works for EXIF and filesystem date formats)
    year=$(echo "$photo_date" | cut -d':' -f1)
    month=$(echo "$photo_date" | cut -d':' -f2)
    day=$(echo "$photo_date" | cut -d':' -f3 | cut -d' ' -f1)

    # Ensure day is numeric (in case exiftool output includes timezone)
    day=$(echo "$day" | sed 's/[^0-9]//g')

    target_dir="${move_dir}/${year}/${year}${month}${day}"
    mkdir -p "$target_dir"

    echo "  Moving to: $target_dir"
    mv -n "$photo" "$target_dir/"
done

