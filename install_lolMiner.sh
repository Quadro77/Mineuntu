#stop && wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.88/lolMiner_v1.88_Lin64.tar.gz
#tar -xvf lolMiner_v1.88_Lin64.tar.gz
#cp -adpR 1.88/lolMiner /app-data/miners/lolminer-1.87 && start
https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.88/lolMiner_v1.88_Lin64.tar.gz
https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.88/lolMiner_v1.88_Lin64.tar.gz
#############################################################################################################
#wget -O install_lolMiner.sh https://raw.githubusercontent.com/Quadro77/Mineuntu/main/install_lolMiner.sh
#chmod +x install_lolMiner.sh
#./install_lolMiner.sh
#############################################################################################################
#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31mThis script must be run as root\e[0m" 
    exit 1
fi

# GitHub repository owner & name
owner=Lolliedieb
repo=lolMiner-releases

# The executable of the miner name
software=lolMiner 

# Set user account
username=$(whoami)
folder_path="/home/$username/miners/lolminer"

apt-get update
# install a CLI JSON processor
apt-get install jq -y

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

# Get the latest release information from GitHub API
latest_release=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")

# Parse the response to extract the version number
latest_version=$(echo "$latest_release" | jq -r '.tag_name')

# Check if the installed version is different from the latest version
if [ -f "$folder_path/version.txt" ]; then
    installed_version=$(<"$folder_path/version.txt")
    if [ "$installed_version" == "$latest_version" ]; then
        echo -e "\e[32m$software is already up to date. Installed version: $installed_version\e[0m"
        exit 0
    fi
fi
# Change directory to /home/$username/tmp
cd /home/$username/tmp || { echo -e "\e[31mError: Failed to change directory to /home/$username/tmp\e[0m"; exit 1; }

# Download the latest release
echo -e "\e[32mDownloading $software $latest_version...\e[0m"

#compessed file name ie lolMiner_v1.88_Lin64.tar.gz
archive_file="lolMiner_v"$latest_version"_Lin64"
echo -e "\e[32mhttps://github.com/$owner/$repo/releases/download/$latest_version/$archive_file.tar.gz\e[0m"
wget "https://github.com/$owner/$repo/releases/download/$latest_version/$archive_file.tar.gz" || { echo -e "\e[31mError: Failed to download $software archive\e[0m"; exit 1; }

# Extract the downloaded archive
echo -e "\e[32mExtracting $software archive...\e[0m"
tar -xzvf "$archive_file.tar.gz" || { echo -e "\e[31mError: Failed to extract $software archive\e[0m"; exit 1; }

# Change directory to the extracted directory
cd "$repo-$latest_version" || { echo -e "\e[31mError: Failed to change directory to $repo-$latest_version\e[0m"; exit 1; }

# Copy the executable
echo -e "\e[32mCopying $software executable to $folder_path...\e[0m"
cp $software "$folder_path/" || { echo -e "\e[31mError: Failed to copy $software executable\e[0m"; exit 1; }

# Validate script path
if [ ! -f "$folder_path/$software" ]; then
    echo -e "\e[31mError: $software not found at $folder_path\e[0m"
    exit 1
fi

# Save installed version to a file for future checks
echo "$latest_version" > "$folder_path/version.txt"

# Clean up all files in the /tmp directory
echo -e "\e[32mCleaning up all temporary files...\e[0m"
rm -rf /home/$username/tmp/*

echo -e "\e[32m$software has been successfully installed.\e[0m"
