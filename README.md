# PCLEAN 🚀

**P**ersonal **I**n-**L**aptop **O**rganized **T**rash **E**liminator

cleanup utility for Linux systems that operates without requiring sudo privileges.

## Overview

pclean is a lightweight cleanup script designed to free up disk space by removing unnecessary files from your 42 user directory. It provides a visually appealing interface with real-time feedback on the cleaning process.

## Features

- **No sudo required**: Works entirely within user permissions
- **Smart scanning**: Identifies and cleans common space-hogging locations
- **Safe operation**: Preview mode to see what would be deleted
- **Detailed reporting**: Shows space saved and cleanup statistics

## What PILOT Cleans

- **Browser caches**: Chrome, Firefox, Brave browser caches
- **Application caches**: General cache directory, VSCode, Discord, Slack
- **Development caches**: NPM, Gradle, Maven, Cargo, VSCode workspaces
- **Build directories**: Automatically finds and cleans build outputs
- **Temporary files**: Old files in Downloads, user's tmp files
- **Thumbnails**: Various thumbnail caches

## Installation

```bash
# Download the script

# Make it executable
chmod +x pclean

# Optional: Move to your bin directory for system-wide access
mv pclean ~/.local/bin/
```

## Usage

### Basic Cleanup

```bash
./pclean
```

### Preview Mode (No Deletion)

```bash
./pclean -p
# or
./pclean --print
```

### Get Help

```bash
./pclean -h
# or
./pclean --help
```

ing off... ✓
```

## Customization

You can easily modify the script to add more locations to clean or change the appearance:

- Edit the `clean_location` function calls to add new directories

## Compatibility

- Works on most Linux distributions
- Partial macOS support (some paths may differ)
- Requires: bash, standard Unix utilities (du, find, rm)

## License

MIT License - Feel free to modify and distribute as needed.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests to improve PCLEAN.

---

**Note**: Always use cleanup tools with caution. While PCLEAN is designed to be safe and only clean temporary files, it's always a good idea to run with the `-p` flag first to see what would be deleted.
