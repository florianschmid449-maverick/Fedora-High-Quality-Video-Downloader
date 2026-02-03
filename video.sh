#!/bin/bash

# ==========================================
#  High-Quality Video Downloader (Fedora)
#  - Auto-installs to /usr/local/bin
#  - Auto-updates yt-dlp on every run
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ------------------------------------------
# 1. Self-Installation Logic
# ------------------------------------------
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="video"
TARGET_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Check if we are running the installed version
if [ "$0" != "$TARGET_PATH" ]; then
    # Check if the file already exists in the target to avoid re-copying if running from source
    # (But logic here assumes if you run ./video you want to install it)
    
    echo -e "${BLUE}[i] First-time setup: Installing '$SCRIPT_NAME' to system path...${NC}"
    
    # Copy current script to target
    sudo cp "$0" "$TARGET_PATH"
    sudo chmod +x "$TARGET_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Installed successfully!${NC}"
        echo -e "    You can now delete this file and type '${BLUE}video${NC}' anywhere."
        echo "---------------------------------------------------"
        # Optional: Switch execution to the installed binary immediately
        exec "$TARGET_PATH" "$@"
    else
        echo -e "${RED}[!] Installation failed. Need sudo rights.${NC}"
        exit 1
    fi
fi

# ------------------------------------------
# 2. Dependency Check & Auto-Update
# ------------------------------------------
ensure_dependencies_and_update() {
    local missing=0
    
    # Check if tools exist
    if ! command -v yt-dlp &> /dev/null; then missing=1; fi
    if ! command -v ffmpeg &> /dev/null; then missing=1; fi

    if [ $missing -eq 1 ]; then
        echo -e "${BLUE}[i] Installing dependencies (yt-dlp, ffmpeg)...${NC}"
        sudo dnf install yt-dlp ffmpeg -y
    else
        # If tools exist, user requested we update yt-dlp every time
        echo -e "${BLUE}[i] Checking for yt-dlp updates...${NC}"
        sudo dnf upgrade yt-dlp -y --quiet
    fi
}

# ------------------------------------------
# 3. Main Logic
# ------------------------------------------
ensure_dependencies_and_update

# Handle URL input (Argument vs Interactive)
if [ -n "$1" ]; then
    TARGET_URL="$1"
else
    echo -e "${BLUE}Enter the Video or Playlist URL:${NC}"
    read -r TARGET_URL
fi

if [ -z "$TARGET_URL" ]; then
    echo -e "${RED}Error: No URL provided. Exiting.${NC}"
    exit 1
fi

echo -e "${BLUE}[i] Downloading Best Quality:${NC} $TARGET_URL"
echo "---------------------------------------------------"

# Download Command
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%(title)s.%(ext)s" "$TARGET_URL"

if [ $? -eq 0 ]; then
    echo "---------------------------------------------------"
    echo -e "${GREEN}[✓] Done.${NC}"
else
    echo -e "${RED}[X] Download failed.${NC}"
fi
