#!/bin/bash
# Rip a disc to ISO using ddrescue
# Usage: ./rip-disc.sh <name>
# Example: ./rip-disc.sh boda_padres_2003

if [ -z "$1" ]; then
    echo "Usage: ./rip-disc.sh <name>"
    echo "Example: ./rip-disc.sh boda_padres_2003"
    exit 1
fi

NAME="$1"
OUTDIR="${2:-$HOME/DVDs}"
ISO="$OUTDIR/disc_${NAME}.iso"
LOG="$OUTDIR/disc_${NAME}.log"

mkdir -p "$OUTDIR"

echo "=== Ripping disc to: $ISO ==="
echo "Log file: $LOG"
echo ""

ddrescue -d -b2048 -n /dev/sr0 "$ISO" "$LOG"

EXIT=$?
if [ $EXIT -eq 0 ]; then
    SIZE=$(du -h "$ISO" | cut -f1)
    echo ""
    echo "Done! ISO saved: $ISO ($SIZE)"
    echo ""
    echo "Next steps:"
    echo "  Mount it:   ./mount-iso.sh $ISO"
    echo "  Convert:    ./convert-vob.sh <name> (after mounting)"
else
    echo ""
    echo "ddrescue exited with errors. Check the log: $LOG"
    echo "You can resume by running the same command again."
fi
