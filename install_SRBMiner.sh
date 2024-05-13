###############################################################################################################
#wget https://raw.githubusercontent.com/owner/repo/branch/path/to/file
###############################################################################################################
#!/bin/bash
# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31mThis script must be run as root\e[0m" 
    exit 1
fi

# Set user account
username=$(whoami)
folder_path="/home/$username/miners/srbminer"

# Check if script path is valid, create if it doesn't exist
if [ ! -d "$folder_path" ]; then
    echo -e "\e[32m$folder_path does not exist, creating it...\e[0m"
    mkdir -p "$folder_path" || { echo -e "\e[31mError: Failed to create $folder_path directory\e[0m"; exit 1; }
fi

# Check if /tmp directory exists
if [ ! -d "/home/$username/tmp" ]; then
    echo -e "\e[32m/home/$username/tmp directory does not exist, creating it...\e[0m"
    mkdir /home/$username/tmp || { echo -e "\e[31mError: Failed to create /home/$username/tmp directory\e[0m"; exit 1; }
fi

# GitHub repository owner and name
owner=doktor83
repo=SRBMiner-Multi

# Get the latest release information from GitHub API
latest_release=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")

# Parse the response to extract the version number
latest_version=$(echo "$latest_release" | jq -r '.tag_name')

# Check if the installed version is different from the latest version
if [ -f "$folder_path/version.txt" ]; then
    installed_version=$(<"$folder_path/version.txt")
    if [ "$installed_version" == "$latest_version" ]; then
        echo -e "\e[32mSRBMiner-Multi is already up to date. Installed version: $installed_version\e[0m"
        exit 0
    fi
fi
# Change directory to /home/$username/tmp
cd /home/$username/tmp || { echo -e "\e[31mError: Failed to change directory to /home/$username/tmp\e[0m"; exit 1; }

# Download the latest release
echo -e "\e[32mDownloading SRBMiner-Multi $latest_version...\e[0m"
version_with_hyphens="${latest_version//./-}"
wget "https://github.com/$owner/$repo/releases/download/$latest_version/$repo-$version_with_hyphens-Linux.tar.gz" || { echo -e "\e[31mError: Failed to download SRBMiner-Multi archive\e[0m"; exit 1; }

# Extract the downloaded archive
echo -e "\e[32mExtracting SRBMiner-Multi archive...\e[0m"
tar -xzvf "$repo-$version_with_hyphens-Linux.tar.gz" || { echo -e "\e[31mError: Failed to extract SRBMiner-Multi archive\e[0m"; exit 1; }

# Change directory to the extracted SRBMiner-Multi directory
cd "$repo-$version_with_hyphens" || { echo -e "\e[31mError: Failed to change directory to $repo-$latest_version\e[0m"; exit 1; }

# Copy the SRBMiner-MULTI executable
echo -e "\e[32mCopying SRBMiner-MULTI executable to $folder_path...\e[0m"
cp SRBMiner-MULTI "$folder_path/" || { echo -e "\e[31mError: Failed to copy SRBMiner-MULTI executable\e[0m"; exit 1; }

# Validate script path
if [ ! -f "$folder_path/SRBMiner-MULTI" ]; then
    echo -e "\e[31mError: SRBMiner-MULTI not found at $folder_path\e[0m"
    exit 1
fi

# Save installed version to a file for future checks
echo "$latest_version" > "$folder_path/version.txt"

# Clean up all files in the /tmp directory
echo -e "\e[32mCleaning up all temporary files...\e[0m"
rm -rf /home/$username/tmp/*

echo -e "\e[32mSRBminer has been successfully installed.\e[0m"
