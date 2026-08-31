#!/bin/bash
# Check what disc is in the drive and show its status

echo "Waiting for disc to spin up..."
sleep 5

INFO=$(udevadm info --query=property --name=/dev/sr0 2>/dev/null | grep MEDIA)

if [ -z "$INFO" ]; then
    echo "No disc detected. Try ejecting, reinserting, and running again."
    exit 1
fi

echo ""
echo "=== Disc Info ==="
echo "$INFO"
echo ""

STATE=$(echo "$INFO" | grep "MEDIA_STATE=" | cut -d= -f2)
TYPE=""
if echo "$INFO" | grep -q "MEDIA_DVD"; then TYPE="DVD"; fi
if echo "$INFO" | grep -q "MEDIA_CD"; then TYPE="CD"; fi
if echo "$INFO" | grep -q "MEDIA_CD_R"; then TYPE="CD-R"; fi
if echo "$INFO" | grep -q "MEDIA_DVD_R"; then TYPE="DVD-R"; fi

echo "Type: $TYPE"
echo "State: $STATE"

if [ "$STATE" = "blank" ]; then
    echo "This disc is BLANK (never written to)."
elif [ "$STATE" = "complete" ]; then
    echo "This disc is FINALIZED (good, should be readable)."
elif [ "$STATE" = "appendable" ]; then
    echo "This disc is APPENDABLE (not finalized, might still be readable)."
else
    echo "Unknown state."
fi
