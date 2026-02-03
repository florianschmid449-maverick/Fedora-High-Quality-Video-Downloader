# High-Quality Video Downloader (Fedora)

A streamlined Bash script designed for Fedora users to download videos at the highest possible quality without the hassle of manual dependency management.

## ✨ Features

* **Self-Installing**: Automatically moves itself to `/usr/local/bin/video` on the first run, allowing you to use the `video` command from any directory.
* **Auto-Updating**: Ensures `yt-dlp` is updated via `dnf` every time the script is executed to maintain compatibility with video sites.
* **Automatic Dependency Handling**: Checks for and installs `yt-dlp` and `ffmpeg` using `dnf` if they are not already present on the system.
* **Best Quality Output**: Specifically configured to pull the best video and audio streams and merge them into a high-quality `.mp4` file.
* **Flexible Inputs**: Supports both direct command-line arguments and interactive URL prompts.

## 🚀 Installation & Usage

### 1. Initial Setup
Download the script and make it executable:
```bash
chmod +x video.sh
