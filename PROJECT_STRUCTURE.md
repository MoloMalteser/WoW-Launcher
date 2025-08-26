# Arctium WoW Launcher - Project Structure

## Complete Project Organization

```
arctium-wow-launcher-godot/
├── project.godot                    # Main Godot project configuration
├── generate_icon.gd                 # Icon generation script
│
├── scripts/                         # All GDScript files
│   ├── launcher.gd                  # Core launcher logic
│   ├── main_ui.gd                   # Main UI controller
│   ├── mod_loader.gd                # Custom file loading
│   ├── settings_manager.gd          # Settings management
│   ├── touch_joystick.gd            # Mobile joystick controls
│   ├── game_integration.gd          # WoW game integration
│   ├── asset_manager.gd             # Asset management system
│   └── icon_generator.gd            # Icon generation utility
│
├── scenes/                          # Godot scene files
│   └── main.tscn                    # Main UI scene
│
├── assets/                          # All project assets
│   ├── icon.png                     # Application icon (generated)
│   ├── textures/                    # UI and game textures
│   │   ├── background.png           # Main background
│   │   ├── button_normal.png        # Button states
│   │   ├── button_pressed.png
│   │   ├── joystick_bg.png          # Mobile controls
│   │   ├── joystick_handle.png
│   │   └── README.md                # Texture guidelines
│   ├── icons/                       # Game and status icons
│   │   ├── game_retail.png
│   │   ├── game_classic.png
│   │   └── game_classic_era.png
│   ├── fonts/                       # Custom fonts
│   ├── sounds/                      # Audio assets
│   └── themes/                      # UI themes
│
├── mappings/                        # Custom file mappings
│   └── (user-created mapping files)
│
├── files/                           # Custom mod files
│   └── (user-created mod files)
│
├── build/                           # Export output directory
│   ├── windows/
│   ├── linux/
│   ├── macos/
│   ├── android/
│   └── ios/
│
├── user://                          # User data (runtime)
│   ├── settings.cfg                 # User settings
│   └── logs/                        # Application logs
│
├── README_GODOT.md                  # Main documentation
├── ASSETS_GUIDE.md                  # Assets and game integration guide
├── PORT_SUMMARY.md                  # Port summary and comparison
├── PROJECT_STRUCTURE.md             # This file
└── build.gd                         # Build automation script
```

## File Descriptions

### Core Scripts
- **`launcher.gd`**: Replicates the original C# launcher functionality
- **`main_ui.gd`**: Handles UI interactions and mobile detection
- **`mod_loader.gd`**: Manages custom files and mappings
- **`settings_manager.gd`**: Handles user preferences and mobile settings
- **`touch_joystick.gd`**: Mobile touch controls implementation
- **`game_integration.gd`**: WoW game detection and management
- **`asset_manager.gd`**: Asset loading and placeholder generation
- **`icon_generator.gd`**: Creates application icons programmatically

### Scenes
- **`main.tscn`**: Main UI scene with mobile controls

### Assets
- **`icon.png`**: Application icon (256x256, generated)
- **`textures/`**: UI textures and mobile control graphics
- **`icons/`**: Game-specific and status icons
- **`fonts/`**: Custom fonts for the application
- **`sounds/`**: Audio feedback for mobile devices
- **`themes/`**: UI themes and styling

### Configuration
- **`project.godot`**: Complete Godot project configuration with:
  - Export presets for all platforms
  - Autoload scripts for global access
  - Input mappings
  - Rendering settings
  - Mobile-specific configurations

### User Data
- **`mappings/`**: User-created file mapping files
- **`files/`**: User-created custom mod files
- **`user://settings.cfg`**: Persistent user settings

## Autoload Scripts

The project uses Godot's autoload system for global script access:

```gdscript
# These scripts are automatically loaded and available globally
Launcher              # Core launcher functionality
GameIntegration       # WoW game integration
AssetManager          # Asset management
SettingsManager       # Settings management
ModLoader             # Custom file loading
```

## Export Presets

Pre-configured export presets for all platforms:

- **Windows Desktop**: Native executable
- **Linux/X11**: Native binary
- **macOS**: App bundle
- **Android**: APK with touch controls
- **iOS**: IPA with touch controls

## Asset Management

### Automatic Asset Loading
- Placeholder generation for missing assets
- Support for PNG, JPG, TTF, OGG, WAV formats
- Efficient caching and memory management
- Error handling for corrupted assets

### Dynamic Asset Creation
- Game-type specific icons
- Status indicators
- UI element placeholders

## Game Integration

### WoW Detection
- Automatic scanning of common installation paths
- Version reading from game binaries
- Configuration file management
- Backup and restore functionality

### Cross-Platform Support
- Windows: Program Files directories
- Linux: /opt, /usr/local/games
- macOS: /Applications
- Current directory subfolders

## Mobile Features

### Touch Controls
- Virtual joystick with customizable settings
- Action buttons for mobile interaction
- Responsive UI that adapts to screen size
- Touch gesture support

### Mobile Optimization
- Touch-friendly interface elements
- Optimized asset loading for mobile
- Battery-efficient operations
- Platform-specific optimizations

## Development Workflow

### Setting Up the Project
1. Open `project.godot` in Godot 4.2+
2. Run `generate_icon.gd` to create the application icon
3. The project is ready to run and export

### Adding Assets
1. Place assets in appropriate directories under `assets/`
2. Use the asset manager to load them in scripts
3. Assets are automatically cached and managed

### Custom Files and Mods
1. Create mapping files in `mappings/` directory
2. Place custom files in `files/` directory
3. The mod loader will handle loading and validation

### Building for Distribution
1. Use the export presets in Project → Export
2. Configure platform-specific settings
3. Export to the `build/` directory

## File Naming Conventions

### Scripts
- Use snake_case for file names
- Descriptive names that indicate functionality
- Group related functionality in the same script

### Assets
- Use descriptive names with underscores
- Include size information in comments
- Follow platform-specific naming conventions

### Scenes
- Use descriptive names ending in `.tscn`
- Group related UI elements in the same scene

## Dependencies

### Required
- Godot 4.2 or later
- World of Warcraft installation (any supported version)

### Optional
- Custom assets for enhanced UI
- Mapping files for custom mods
- Custom fonts for branding

## Performance Considerations

### Asset Optimization
- Use appropriate texture sizes
- Compress assets for mobile
- Implement lazy loading for large assets

### Memory Management
- Proper cleanup of unused assets
- Efficient caching strategies
- Monitor memory usage on mobile

### Cross-Platform Compatibility
- Test on all target platforms
- Handle platform-specific differences
- Optimize for each platform's strengths