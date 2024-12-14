#!/bin/bash

# Step 1: Download the latest VS Code .deb package
# Specify the download URL for the VS Code .deb package
VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb"
DOWNLOAD_DIR="$HOME/Downloads"
VSCODE_DEB="$DOWNLOAD_DIR/code_latest.deb"

# Create the download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Download the .deb package
echo "Downloading VS Code .deb package to $DOWNLOAD_DIR..."
curl -L "$VSCODE_URL" -o "$VSCODE_DEB"

# Step 2: Extract the .deb package locally
INSTALL_DIR="$HOME/vscode"
mkdir -p "$INSTALL_DIR"

# Extract the contents of the .deb package
echo "Extracting VS Code package to $INSTALL_DIR..."
dpkg-deb -x "$VSCODE_DEB" "$INSTALL_DIR"
dpkg-deb -e "$VSCODE_DEB" "$INSTALL_DIR/DEBIAN"

# Step 3: Run VS Code locally
BINARY_PATH="$INSTALL_DIR/usr/share/code/code"
if [ -f "$BINARY_PATH" ]; then
    echo "VS Code extracted successfully. You can run it using:"
    echo "$BINARY_PATH"
else
    echo "Error: VS Code binary not found. Check the installation directory."
    exit 1
fi

# Step 4: Add VS Code to PATH (Optional)
ZSHRC="$HOME/.zshrc"
PATH_ENTRY="export PATH=\"$INSTALL_DIR/usr/share/code:\$PATH\""

if ! grep -Fxq "$PATH_ENTRY" "$ZSHRC"; then
    echo "Adding VS Code to PATH in $ZSHRC..."
    echo "$PATH_ENTRY" >> "$ZSHRC"
    echo "Reloading shell configuration..."
    source "$ZSHRC"
else
    echo "VS Code is already in your PATH."
fi

# Final message
echo "Setup complete! You can now run VS Code using the command: code"
