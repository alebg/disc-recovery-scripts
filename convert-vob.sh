#!/bin/bash
# Convert mounted DVD VOB files to MP4
# Usage: ./convert-vob.sh <output-name> [output-dir]
# Example: ./convert-vob.sh boda_padres_2003

if [ -z "$1" ]; then
    echo "Usage: ./convert-vob.sh <output-name> [output-dir]"
    echo "Example: ./convert-vob.sh boda_padres_2003"
    exit 1
fi

NAME="$1"
OUTDIR="${2:-$HOME/DVDs}"
MOUNTPOINT="/tmp/dvdmount"
VIDEODIR="$MOUNTPOINT/VIDEO_TS"

if ! sudo test -d "$VIDEODIR"; then
    echo "No VIDEO_TS found at $MOUNTPOINT. Mount an ISO first:"
    echo "  ./mount-iso.sh <path-to-iso>"
    exit 1
fi

VOBS=$(sudo ls "$VIDEODIR"/VTS_01_*.VOB 2>/dev/null | grep -v VTS_01_0.VOB | sort)

if [ -z "$VOBS" ]; then
    echo "No VTS_01_*.VOB files found in $VIDEODIR"
    exit 1
fi

CONCAT=$(echo "$VOBS" | tr '\n' '|' | sed 's/|$//')
COUNT=$(echo "$VOBS" | wc -l)

echo "=== Converting $COUNT VOB files to MP4 ==="
echo "Output: $OUTDIR/${NAME}.mp4"
echo ""

sudo ffmpeg -i "concat:$CONCAT" -c:v libx264 -crf 18 -c:a aac -b:a 192k "$OUTDIR/${NAME}.mp4"

if [ $? -eq 0 ]; then
    sudo chown $USER:$USER "$OUTDIR/${NAME}.mp4"
    SIZE=$(du -h "$OUTDIR/${NAME}.mp4" | cut -f1)
    echo ""
    echo "Done! MP4 saved: $OUTDIR/${NAME}.mp4 ($SIZE)"
else
    echo ""
    echo "Conversion failed. Check ffmpeg output above."
fi
