#!/bin/bash
# Mount an ISO file and show its contents
# Usage: ./mount-iso.sh <path-to-iso>

if [ -z "$1" ]; then
    echo "Usage: ./mount-iso.sh <path-to-iso>"
    exit 1
fi

ISO="$1"
MOUNTPOINT="/tmp/dvdmount"

mkdir -p "$MOUNTPOINT"
sudo umount "$MOUNTPOINT" 2>/dev/null

echo "Mounting $ISO..."
sudo mount -o loop,ro "$ISO" "$MOUNTPOINT"

if [ $? -eq 0 ]; then
    echo "Mounted at $MOUNTPOINT"
    echo ""
    echo "=== Contents ==="
    ls -lh "$MOUNTPOINT"/
    if [ -d "$MOUNTPOINT/VIDEO_TS" ]; then
        echo ""
        echo "=== VIDEO_TS (DVD Video) ==="
        ls -lh "$MOUNTPOINT/VIDEO_TS/"
        echo ""
        echo "This is a DVD video disc. Convert with:"
        echo "  ./convert-vob.sh <output-name>"
    fi
else
    echo "Failed to mount. The ISO might be damaged or incomplete."
fi
