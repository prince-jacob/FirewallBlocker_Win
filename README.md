# AutoIt Firewall Blocker


## Overview

This AutoIt script provides a graphical user interface (GUI) for scanning a folder, listing executable (.exe) files, and blocking selected .exe files in both inbound and outbound Windows Firewall rules.

## Features

- Browse and select a folder for scanning.
- Scan the selected folder and list all executable (.exe) files in the ListView.
- Check the checkboxes to select specific .exe files for blocking.
- Block selected .exe files in both inbound and outbound Windows Firewall rules.
- Clear the list of scanned files.
- Automatic adjustment of column width in the ListView based on content.

## Prerequisites

- AutoIt (Download and install from [AutoIt Downloads](https://www.autoitscript.com/site/autoit/downloads/))
- Windows operating system (Administrator privileges required for blocking firewall rules)

## Usage

1. Run the script (`firewall.au3`) using AutoIt.
2. Click the "Browse" button to select a folder for scanning.
3. Click "Scan Folder" to scan the selected folder and list executable files in the ListView.
4. Check the checkboxes next to .exe files you want to block.
5. Click "Block Selected" to create both inbound and outbound firewall rules for the selected .exe files.
6. Use "Clear List" to remove all items from the ListView.

## Screenshots



## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
