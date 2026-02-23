#!/bin/bash

# Define paths
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="tonaufnahmen-vorbereitung.ps1"
TARGET_DIR="/Users/mklassen/Library/CloudStorage/SynologyDrive-EFSS-MediaTEAM/Technik/Tontechnik/Tools/Tonaufnahmen-Vorbereitung"

echo "Deploying $SCRIPT_NAME..."

# Check if source exists
if [ ! -f "$SOURCE_DIR/$SCRIPT_NAME" ]; then
    echo "Error: Source script $SOURCE_DIR/$SCRIPT_NAME not found."
    exit 1
fi

# Create target directory if it doesn't exist (just in case)
mkdir -p "$TARGET_DIR"

# Copy the file
cp "$SOURCE_DIR/$SCRIPT_NAME" "$TARGET_DIR/"

# Check if copy was successful
if [ $? -eq 0 ]; then
    echo "Success! The script has been updated in the target directory."
else
    echo "Error: Failed to copy the script."
    exit 1
fi
