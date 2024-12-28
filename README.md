# Plex Media Server Setup Script

This script automates the installation of Plex Media Server on **Raspbian OS Lite**. It checks for necessary prerequisites, installs required packages, and sets up your system to host a Plex Media Server.

## Features

- Installs Plex Media Server.
- Configures the boot process with a static IP address.
- Creates directories for media libraries (`Movies` and `Shows`).
- Provides instructions for transferring media files.
- Outputs the URL to access the Plex server after installation.

## Requirements

- **Raspbian OS Lite**: This script is only tested and designed for Raspbian OS Lite.
- **Root Access**: The script must be run as the root user or with `sudo`.
- **Static IP Address**: You will need to provide a valid IPv4 address (for static ip).
- **Finalize**: Additional setup required when you first visit the website

## Usage

### 1. Clone or download the script
```bash
git clone <repository-url>
cd <repository-directory>
