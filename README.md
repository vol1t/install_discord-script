# Install Discord Script

Manual Discord installer for **Arch Linux and Arch-based distributions**, using the official `.tar.gz` package instead of `.deb`, Flatpak or Snap.

---

## Overview

This Bash script downloads and installs the latest official Discord release directly from Discord’s website.  
It performs a clean installation under `/opt` and configures system-wide access.

---

## Features

- Downloads Discord from the official source
- Installs to `/opt/discord`
- Creates a symbolic link at `/usr/bin/discord`
- Creates a desktop entry for application menus
- Removes previous installations automatically
- Cleans up temporary files

---

## Requirements

- Arch Linux or Arch-based distribution
- Root privileges (`sudo`)
- Installed packages:
  - `bash`
  - `curl`
  - `tar`

```bash
sudo pacman -S curl tar
```
--- 

## Installation

Clone the repository:

```bash
git clone https://github.com/vol1t/install_discord-script.git
cd install_discord-script
```

Make the script executable:

```bash
chmod +x install_discord.sh
```

Run the script as root:
```bash
sudo ./install_discord.sh
```
