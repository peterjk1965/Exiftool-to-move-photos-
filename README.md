Exiftool-to-move-photos-

I wanted to move photos from my dropbox to a usp drive. 
Also wanted to rename some photos from HEIC format to .jpg
Move photos based on DateTimeOriginal EXIF tag
Sort JPGs (your fallback date logic)

STEPS:
Save as bash file as photo_sort_debug.sh.
Run it.

Watch the output — especially the DateTimeOriginal line.
If it’s blank for every file, then exiftool isn’t reading that tag (could be CreateDate, ModifyDate, or FileModifyDate instead).
If it shows a date but still doesn’t move, then it’s a path/permissions issue.


#PREREQUISITES, Im on windows 11:
wsl --install
sudo apt update 
sudo apt install imagemagick -y   Install ImageMagick in WSL
sudo apt install libheif-examples -y  If you don’t need the extra features of ImageMagick and only want HEIC → JPG conversion:

How this works
Converts HEIC → JPG only if a JPG doesn’t already exist.
Keeps EXIF metadata (important for sorting).
Falls back through multiple date fields so even edited or downloaded files get sorted.
Uses mv -n to avoid overwriting duplicates.
