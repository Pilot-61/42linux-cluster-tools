#!/bin/bash

# Step 1: Define the correct VS Code download URL
DOWNLOAD_URL="https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
OUTPUT_FILE="code.deb"

echo "Downloading VS Code..."
wget -O "$OUTPUT_FILE" "$DOWNLOAD_URL"

# Check if the download was successful
if [[ $? -ne 0 || ! -f $OUTPUT_FILE ]]; then
  echo "Error: Failed to download VS Code. Please check your internet connection and the URL."
  exit 1
fi

# Step 2: Extract the .deb package
echo "Extracting the VS Code package..."
dpkg-deb -x "$OUTPUT_FILE" ~/vscode
dpkg-deb -e "$OUTPUT_FILE" ~/vscode/DEBIAN

# Verify if extraction was successful
if [[ ! -d ~/vscode/usr/share/code ]]; then
  echo "Error: Extraction failed. Please check if dpkg-deb is installed and working correctly."
  exit 1
fi

# Step 3: Navigate to the extracted directory and run VS Code
echo "Launching VS Code..."
cd ~/vscode/usr/share/code || exit 1
./code &

# Step 4: Add VS Code to PATH in .zshrc
echo "Adding VS Code to PATH..."
echo 'export PATH=~/vscode/usr/share/code:$PATH' >> ~/.zshrc

# Reload .zshrc to apply changes
if [[ -n "$ZSH_VERSION" ]]; then
  source ~/.zshrc
else
  echo "Warning: .zshrc not reloaded. Please run 'source ~/.zshrc' manually."
fi

echo "VS Code setup is complete. You can now run 'code' from anywhere."
