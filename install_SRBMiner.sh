#!/bin/bash
# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi
# Set user account
username=$(whoami)
script_path="/home/$username/miners/sbrminer"
# Check if script path is valid, create if it doesn't exist
if [ ! -d "$script_path" ]; then
    echo "$script_path does not exist, creating it..."
    mkdir -p "$script_path" || { echo "Error: Failed to create $script_path directory"; exit 1; }
fi
# Check if /tmp directory exists
if [ ! -d "/tmp" ]; then
    echo "/tmp directory does not exist, creating it..."
    mkdir /tmp || { echo "Error: Failed to create /tmp directory"; exit 1; }
fi
# Change directory to /tmp
cd /tmp || { echo "Error: Failed to change directory to /tmp"; exit 1; }
# GitHub repository owner and name
owner=doktor83
repo=SRBMiner-Multi
# Get the latest release information from GitHub API
latest_release=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")
# Parse the response to extract the version number
latest_version=$(echo "$latest_release" | jq -r '.tag_name')
# Check if the installed version is different from the latest version
if [ -f "$script_path/version.txt" ]; then
    installed_version=$(<"$script_path/version.txt")
    if [ "$installed_version" == "$latest_version" ]; then
        echo "SRBMiner-Multi is already up to date. Installed version: $installed_version"
        exit 0
    fi
fi
# Download the latest release
echo "Downloading SRBMiner-Multi $latest_version..."
wget "https://github.com/$owner/$repo/releases/download/$latest_version/$repo-$latest_version-Linux.tar.gz" || { echo "Error: Failed to download SRBMiner-Multi archive"; exit 1; }
# Extract the downloaded archive
echo "Extracting SRBMiner-Multi archive..."
tar -xzvf "$repo-$latest_version-Linux.tar.gz" || { echo "Error: Failed to extract SRBMiner-Multi archive"; exit 1; }

# Change directory to the extracted SRBMiner-Multi directory
cd "$repo-$latest_version" || { echo "Error: Failed to change directory to $repo-$latest_version"; exit 1; }

# Copy the SRBMiner-MULTI executable
echo "Copying SRBMiner-MULTI executable to $script_path..."
cp SRBMiner-MULTI "$script_path/" || { echo "Error: Failed to copy SRBMiner-MULTI executable"; exit 1; }

# Validate script path
if [ ! -f "$script_path/SRBMiner-MULTI" ]; then
    echo "Error: Script not found at $script_path"
    exit 1
fi

# Save installed version to a file for future checks
echo "$latest_version" > "$script_path/version.txt"

# Add sudoers entry
echo "Adding sudoers entry for $username..."
echo "$username ALL=(ALL) NOPASSWD: $script_path/SRBMiner-MULTI" | tee -a /etc/sudoers

echo "Sudoers entry added successfully for $username to run $script_path/SRBMiner-MULTI without password."

# Clean up all files in the /tmp directory
echo "Cleaning up all temporary files..."
rm -rf /tmp/*

echo "SRBminer has been successfully installed."
