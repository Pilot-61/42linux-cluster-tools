#!/bin/bash

# Step 1: Download the VS Code .deb package
echo "Downloading VS Code..."
wget -O code.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

# Check if the download was successful
if [[ ! -f code.deb ]]; then
  echo "Error: Failed to download VS Code. Please check your internet connection and the URL."
  exit 1
fi

# Step 2: Extract the .deb package
echo "Extracting the VS Code package..."
dpkg-deb -x code.deb ~/vscode
dpkg-deb -e code.deb ~/vscode/DEBIAN

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
