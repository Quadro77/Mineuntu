#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Prompt for username and script path
read -p "Enter the username: " username
read -p "Enter the path to the script: " script_path

# Validate script path
if [ ! -f "$script_path" ]; then
    echo "Error: Script not found at $script_path"
    exit 1
fi

# Add sudoers entry
echo "$username ALL=(ALL) NOPASSWD: $script_path" | sudo tee -a /etc/sudoers

echo "Sudoers entry added successfully for $username to run $script_path without password."
