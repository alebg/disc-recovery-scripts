#!/bin/bash
# Copy files from a mounted data disc (photos, etc.) to a local folder
# Usage: ./copy-data-disc.sh <folder-name>
# Example: ./copy-data-disc.sh fotos_carla_2010

if [ -z "$1" ]; then
    echo "Usage: ./copy-data-disc.sh <folder-name>"
    echo "Example: ./copy-data-disc.sh fotos_carla_2010"
    exit 1
fi

NAME="$1"
OUTDIR="${2:-$HOME/DVDs}/$NAME"
MOUNT=$(mount | grep sr0 | awk '{print $3}')

if [ -z "$MOUNT" ]; then
    MOUNT=$(ls -d /media/$USER/* 2>/dev/null | head -1)
fi

if [ -z "$MOUNT" ]; then
    echo "No mounted disc found. Insert a disc and let it automount, or mount manually."
    exit 1
fi

echo "=== Source: $MOUNT ==="
echo "=== Destination: $OUTDIR ==="
echo ""

mkdir -p "$OUTDIR"
echo "Copying files (skipping existing)..."
cp -rn "$MOUNT"/* "$OUTDIR"/

if [ $? -eq 0 ]; then
    COUNT=$(find "$OUTDIR" -type f | wc -l)
    SIZE=$(du -sh "$OUTDIR" | cut -f1)
    echo ""
    echo "Done! $COUNT files copied ($SIZE)"
else
    echo ""
    echo "Some files failed to copy. Try ddrescue for damaged discs:"
    echo "  ./rip-disc.sh $NAME"
fi
