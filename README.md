# Disc Recovery Scripts

Scripts for ripping old CDs/DVDs and converting video to MP4.

## Dependencies

```bash
sudo apt install gddrescue ffmpeg
```

## Scripts

| Script | Purpose |
|--------|---------|
| `check-disc.sh` | Detect what disc is in the drive (type, state) |
| `rip-disc.sh` | Rip a disc to ISO using ddrescue (handles damaged discs) |
| `mount-iso.sh` | Mount an ISO and show its contents |
| `convert-vob.sh` | Convert DVD video (VOB files) to MP4 |
| `copy-data-disc.sh` | Copy files from a data disc (photos, etc.) |

## Workflow

### 1. Always start by checking the disc

```bash
./check-disc.sh
```

This tells you what type of disc it is and whether it's readable.
If it says "blank", the disc was never written to. Move on.
If it says "complete" or "appendable", proceed below.

### 2a. Video DVD (shows VIDEO_TS when mounted)

Rip the disc to ISO, mount it, then convert to MP4:

```bash
./rip-disc.sh wedding_2003
./mount-iso.sh ~/DVDs/disc_wedding_2003.iso
./convert-vob.sh wedding_2003
```

Output: `~/DVDs/wedding_2003.mp4`

### 2b. Data disc (photos, documents, etc.)

If the disc automounts (you see files in the file manager), copy directly:

```bash
./copy-data-disc.sh vacation_photos_2005
```

Output: `~/DVDs/vacation_photos_2005/`

### 2c. Damaged data disc (direct copy fails or stalls)

Fall back to ddrescue, then extract from the ISO:

```bash
./rip-disc.sh damaged_photos
./mount-iso.sh ~/DVDs/disc_damaged_photos.iso
cp -r /tmp/dvdmount/* ~/DVDs/damaged_photos/
```

## Tips

- If the drive won't detect a disc, unplug USB, wait a minute, plug back in, reinsert disc.
- If ddrescue gets stuck (0 B/s for minutes), Ctrl+C it. The .log file saves progress. Run the same command again to resume.
- If Ctrl+C doesn't work, try Ctrl+Z then `kill %1`. Last resort: unplug USB.
- Clean discs before inserting: soft cloth, wipe center to edge, never in circles.
- Eject between discs: `eject /dev/sr0`
- All ISOs and MP4s go to `~/DVDs/` by default. Pass a second argument to change the output directory.
