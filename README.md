# Firewall Blocker

Firewall Blocker is a simple GUI application written in AutoIt that allows users to manage Windows Firewall rules for blocking or unblocking executable files in a specified folder.

## Features

- Browse and select a folder to scan for executable files (.exe).
- View a list of executable files found in the selected folder.
- Select individual files or use "Select All" to choose multiple files for blocking or unblocking.
- Block selected executable files by creating inbound and outbound firewall rules.
- Remove firewall blocks for selected executable files.
- Clear the list of executable files displayed in the GUI.

## Requirements

- Windows operating system with administrative privileges.
- AutoIt scripting language installed.

## Installation

1. Clone or download the repository to your local machine.
2. Ensure you have AutoIt installed on your system.
3. Run the `FirewallBlocker.au3` script to launch the GUI application.

## Usage

1. Launch the application by running the `FirewallBlocker.au3` script.
2. Click the "Browse" button to select a folder to scan for executable files.
3. Click "Scan Folder" to populate the list view with executable files found in the selected folder.
4. Select individual files or use "Select All" to choose multiple files.
5. Click "Block Selected" to create firewall rules blocking the selected executable files.
6. To remove firewall blocks, select the desired files and click "Remove Block."
7. Use the "Clear List" button to clear the list view and start over.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or create a pull request.

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
