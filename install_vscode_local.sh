#!/bin/bash

# Step 1: Download the VS Code .deb package
echo "Downloading VS Code..."
wget -O code.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

# Step 2: Extract the .deb package
echo "Extracting the VS Code package..."
dpkg-deb -x code.deb ~/vscode
dpkg-deb -e code.deb ~/vscode/DEBIAN

# Step 3: Navigate to the extracted directory and run VS Code
echo "Launching VS Code..."
cd ~/vscode/usr/share/code
./code &

# Step 4: Add VS Code to PATH in .zshrc
echo "Adding VS Code to PATH..."
echo 'export PATH=~/vscode/usr/share/code:$PATH' >> ~/.zshrc
source ~/.zshrc

echo "VS Code setup is complete. You can now run 'code' from anywhere."
