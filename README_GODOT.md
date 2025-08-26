# Arctium WoW Launcher - Godot Port

A modern, cross-platform game launcher for World of Warcraft that allows you to connect to custom servers. This is a Godot port of the original C# Arctium WoW Launcher with enhanced mobile support and modern UI.

## Features

### Core Functionality
- **Multi-Version Support**: Launch Retail (10.x), Classic BC/WotLK (2.5.x, 3.4.x), and Classic Era (1.14.x)
- **Auto-Detection**: Automatically detects game installations in standard locations
- **Custom Server Support**: Connect to private/custom WoW servers
- **SSL Certificate Validation**: Validates server certificates for secure connections
- **Developer Mode**: Special mode for local development servers
- **Custom File Loading**: Support for mods and custom files
- **Cache Management**: Optional cache clearing for troubleshooting

### Mobile Features
- **Touch Joystick**: Virtual joystick for mobile navigation
- **Touch Gestures**: Swipe and tap controls
- **Responsive UI**: Adapts to different screen sizes
- **Mobile-Optimized Layout**: Touch-friendly interface elements
- **Action Buttons**: Customizable action buttons for mobile

### Cross-Platform Support
- **Windows**: Full desktop support
- **Android**: Mobile support with touch controls
- **iOS**: Mobile support (requires proper signing)
- **Linux**: Desktop support
- **macOS**: Desktop support

## Installation

### Prerequisites
- [Godot 4.2+](https://godotengine.org/download)
- World of Warcraft installation (any supported version)

### Building from Source

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd arctium-wow-launcher-godot
   ```

2. **Open in Godot**:
   - Launch Godot Engine
   - Click "Import" and select the project folder
   - Wait for the project to import

3. **Build for your platform**:
   - Go to Project → Export
   - Add export presets for your target platforms
   - Click "Export Project"

### Export Presets

#### Windows
- **Target**: Windows Desktop
- **Architecture**: x86_64
- **Embed PCK/ZIP**: Enabled

#### Android
- **Target**: Android
- **Architecture**: arm64-v8a, armeabi-v7a
- **Permissions**: Internet, Write External Storage

#### iOS
- **Target**: iOS
- **Architecture**: arm64
- **Code Signing**: Required

## Usage

### Basic Usage

1. **Launch the application**
2. **Select Game Version**:
   - Retail (10.x) - Current expansion
   - Classic BC/WotLK (2.5.x, 3.4.x) - Burning Crusade/Wrath of the Lich King
   - Classic Era (1.14.x) - Vanilla WoW

3. **Configure Options**:
   - **Game Path**: Manually specify WoW installation (optional)
   - **Developer Mode**: Enable for local servers without valid certificates
   - **Keep Cache**: Preserve game cache files
   - **Static Auth Seed**: Use static authentication seed
   - **Skip Connection Patching**: Skip memory patching

4. **Click "Launch Game"**

### Mobile Controls

When running on mobile devices:

- **Touch Joystick**: Located at bottom-left, provides directional input
- **Action Buttons**: Located at bottom-right, customizable actions
- **Swipe Gestures**: Navigate through menus
- **Pinch to Zoom**: Adjust UI scale (if supported)

### Custom Files and Mods

1. **Create folders**:
   ```
   your-launcher-folder/
   ├── mappings/
   │   └── your-mapping.txt
   └── files/
       └── your-mod-files/
   ```

2. **Mapping file format** (mappings/your-mapping.txt):
   ```
   fileId;filePath
   12345;Interface/AddOns/MyAddon/MyAddon.toc
   67890;Data/common.MPQ
   ```

3. **Place custom files** in the `files/` folder following the correct structure

### Server Configuration

#### Local Development
- Use **Developer Mode** for local servers
- Server must be on localhost or private IP range
- No valid SSL certificate required

#### External Servers
- **Developer Mode** must be disabled
- Server must have valid SSL certificate
- Certificate must match server hostname

## Configuration

### Game Config Files
The launcher uses standard WoW configuration files:
- `Config.wtf` - Main configuration
- Custom config files can be specified

### Launch Parameters
The launcher supports various command-line parameters:
- `--version` - Game version
- `--path` - Custom game path
- `--dev` - Developer mode
- `--keepcache` - Keep cache files
- `--staticseed` - Use static auth seed
- `--skip` - Skip connection patching

## Troubleshooting

### Common Issues

**Game not found**:
- Verify WoW installation path
- Check if game binary exists in expected location
- Try manual path specification

**Connection failed**:
- Check server status
- Verify SSL certificate (for external servers)
- Enable Developer Mode for local servers

**Mobile controls not working**:
- Ensure running on mobile platform
- Check touch input permissions
- Restart application

**Custom files not loading**:
- Verify mapping file format
- Check file paths in mappings
- Ensure custom files exist in files folder

### Logs and Debugging
- Status messages appear in the right panel
- Check console output for detailed errors
- Enable debug mode for additional logging

## Development

### Project Structure
```
├── scripts/
│   ├── launcher.gd          # Core launcher logic
│   ├── main_ui.gd           # Main UI controller
│   └── mod_loader.gd        # Custom file loading
├── scenes/
│   └── main.tscn           # Main UI scene
├── assets/                 # Images, icons, etc.
└── project.godot          # Godot project file
```

### Adding Features
1. **New Game Versions**: Update `launcher.gd` GameVersion enum
2. **Mobile Controls**: Modify `main_ui.gd` mobile control logic
3. **UI Changes**: Edit `main.tscn` scene file
4. **Custom File Support**: Extend `mod_loader.gd`

### Building for Distribution
1. **Export Settings**: Configure platform-specific settings
2. **Code Signing**: Required for iOS, recommended for Windows
3. **Permissions**: Set appropriate mobile permissions
4. **Testing**: Test on target platforms before distribution

## License

This project maintains the same license as the original Arctium WoW Launcher. Please respect the original project's licensing terms.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues and questions:
- Check the troubleshooting section
- Review the original C# launcher documentation
- Create an issue in the repository

## Acknowledgments

- Original Arctium WoW Launcher team
- Godot Engine community
- WoW private server community

---

**Note**: This launcher is for connecting to custom/private servers only. Do not use with official Blizzard servers as it may result in account bans.