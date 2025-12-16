#!/bin/bash
# Image Optimization Script for Dragonfly Wellness
# This script compresses GIF images to WebP format for faster mobile loading
#
# Prerequisites:
#   sudo apt install ffmpeg
#
# Usage:
#   cd /home/haydeng/projects/dragonfly_wellness/dragonfly_wellness
#   chmod +x optimize-images.sh
#   ./optimize-images.sh

set -e

echo "=========================================="
echo "Dragonfly Wellness Image Optimizer"
echo "=========================================="
echo ""

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "ERROR: ffmpeg is required but not installed."
    echo "Install it with: sudo apt install ffmpeg"
    exit 1
fi

# Create backup directory
BACKUP_DIR="./image-backups-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

echo "Step 1: Backing up original images to $BACKUP_DIR..."
cp about-photo.gif "$BACKUP_DIR/" 2>/dev/null || echo "  - about-photo.gif not found"
cp contact-photo.gif "$BACKUP_DIR/" 2>/dev/null || echo "  - contact-photo.gif not found"
echo "  Done!"
echo ""

# Get original file sizes
ABOUT_SIZE=$(du -h about-photo.gif 2>/dev/null | cut -f1 || echo "N/A")
CONTACT_SIZE=$(du -h contact-photo.gif 2>/dev/null | cut -f1 || echo "N/A")

echo "Step 2: Original file sizes:"
echo "  - about-photo.gif: $ABOUT_SIZE"
echo "  - contact-photo.gif: $CONTACT_SIZE"
echo ""

echo "Step 3: Converting to optimized WebP..."

# Convert about-photo.gif to WebP (animated)
if [ -f "about-photo.gif" ]; then
    echo "  Converting about-photo.gif..."
    ffmpeg -y -i about-photo.gif -vf "scale=800:-1" -loop 0 -preset default -quality 80 about-photo.webp 2>/dev/null
    ABOUT_NEW_SIZE=$(du -h about-photo.webp | cut -f1)
    echo "  - about-photo.webp: $ABOUT_NEW_SIZE (was $ABOUT_SIZE)"
fi

# Convert contact-photo.gif to WebP (animated)
if [ -f "contact-photo.gif" ]; then
    echo "  Converting contact-photo.gif..."
    ffmpeg -y -i contact-photo.gif -vf "scale=600:-1" -loop 0 -preset default -quality 80 contact-photo.webp 2>/dev/null
    CONTACT_NEW_SIZE=$(du -h contact-photo.webp | cut -f1)
    echo "  - contact-photo.webp: $CONTACT_NEW_SIZE (was $CONTACT_SIZE)"
fi

echo ""
echo "Step 4: Creating static fallback images (first frame as JPG)..."

if [ -f "about-photo.gif" ]; then
    ffmpeg -y -i about-photo.gif -vframes 1 -vf "scale=800:-1" -q:v 2 about-photo-static.jpg 2>/dev/null
    echo "  - about-photo-static.jpg created"
fi

if [ -f "contact-photo.gif" ]; then
    ffmpeg -y -i contact-photo.gif -vframes 1 -vf "scale=600:-1" -q:v 2 contact-photo-static.jpg 2>/dev/null
    echo "  - contact-photo-static.jpg created"
fi

echo ""
echo "=========================================="
echo "OPTIMIZATION COMPLETE!"
echo "=========================================="
echo ""
echo "Files created:"
ls -lh *.webp *.jpg 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "Original backups saved to: $BACKUP_DIR"
echo ""
echo "NEXT STEPS:"
echo "1. Update index.html to use WebP with fallbacks:"
echo ""
echo '   <picture>'
echo '     <source srcset="about-photo.webp" type="image/webp">'
echo '     <source srcset="about-photo-static.jpg" type="image/jpeg">'
echo '     <img src="about-photo.gif" alt="Christina" loading="lazy">'
echo '   </picture>'
echo ""
echo "2. Or simply rename the .webp files to .gif to use them directly"
echo "   (WebP is supported by 97%+ of browsers)"
echo ""
