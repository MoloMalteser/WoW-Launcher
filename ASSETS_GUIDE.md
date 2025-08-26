# Assets and Game Integration Guide

## Overview
This guide covers the assets management and game integration features of the Arctium WoW Launcher Godot port.

## Asset Management

### Asset Structure
```
assets/
├── icon.png                    # Application icon (256x256)
├── textures/                   # UI and game textures
│   ├── background.png         # Main background
│   ├── button_normal.png      # Button states
│   ├── button_pressed.png
│   ├── joystick_bg.png        # Mobile controls
│   ├── joystick_handle.png
│   └── README.md              # Texture guidelines
├── icons/                      # Game and status icons
│   ├── game_retail.png
│   ├── game_classic.png
│   └── game_classic_era.png
├── fonts/                      # Custom fonts
├── sounds/                     # Audio assets
└── themes/                     # UI themes
```

### Asset Manager Features

#### Automatic Asset Loading
- **Placeholder Generation**: Creates placeholder assets for missing files
- **Format Support**: PNG, JPG, TTF, OGG, WAV, and Godot resources
- **Caching**: Efficient asset caching and memory management
- **Error Handling**: Graceful handling of missing or corrupted assets

#### Dynamic Asset Creation
- **Game Icons**: Automatically generates game-type specific icons
- **Status Icons**: Creates status indicators (success, error, warning, info)
- **UI Elements**: Generates placeholder textures for missing UI elements

### Adding Custom Assets

#### 1. Textures
```gdscript
# Load a custom texture
var custom_texture = asset_manager.load_asset("custom_ui", "res://assets/textures/custom_ui.png")

# Use the texture
var texture_rect = TextureRect.new()
texture_rect.texture = custom_texture
```

#### 2. Fonts
```gdscript
# Load a custom font
var custom_font = asset_manager.load_font("custom_font.ttf")

# Apply to UI elements
label.add_theme_font_override("font", custom_font)
```

#### 3. Audio
```gdscript
# Load audio for mobile feedback
var click_sound = asset_manager.load_audio("click.ogg")

# Play the sound
AudioStreamPlayer.new().stream = click_sound
```

## Game Integration

### WoW Installation Detection

#### Automatic Detection
The launcher automatically scans for WoW installations in:
- **Windows**: Program Files, Games directory
- **Linux**: /opt, /usr/local/games, ~/Games
- **macOS**: /Applications, ~/Applications
- **Current Directory**: _retail_, _classic_, _classic_era subdirectories

#### Manual Detection
```gdscript
# Manually scan a directory
var installations = game_integration.detect_wow_installations()

# Check specific path
var games = game_integration._scan_directory_for_games("/path/to/wow")
```

### Game Version Reading

#### Binary Version Detection
```gdscript
# Read version from game binary
var version_info = game_integration._read_game_version("Wow.exe")

# Version info contains:
# - major: Major version number
# - minor: Minor version number  
# - build: Build number
# - revision: Revision number
# - string: Version string
```

#### Game Type Determination
```gdscript
# Determine game type from binary and version
var game_type = game_integration._determine_game_type("Wow.exe", version_info)

# Returns: "retail", "classic", "classic_era", or "unknown"
```

### Configuration Management

#### Reading Game Config
```gdscript
# Read WoW configuration
var config_path = game_integration.get_game_config_path(game_path)
var config = game_integration.read_game_config(config_path)

# Access config values
var portal = config.get("SET portal", "")
var realm = config.get("SET realmName", "")
```

#### Writing Game Config
```gdscript
# Modify and save configuration
config["SET portal"] = "your-server.com"
config["SET realmName"] = "Your Realm"
game_integration.write_game_config(config_path, config)
```

#### Backup and Restore
```gdscript
# Create backup before modifying
var backup_path = game_integration.backup_game_config(config_path)

# Restore from backup if needed
game_integration.restore_game_config(config_path, backup_path)
```

### Game File Management

#### Required Files Validation
```gdscript
# Validate game installation
var is_valid = game_integration.validate_game_installation(game_path, game_type)

# Checks for:
# - Data/common.MPQ
# - Data/common-2.MPQ  
# - WTF/Config.wtf
```

#### Game Directory Access
```gdscript
# Get game subdirectories
var screenshots_path = game_integration.get_game_screenshots_path(game_path)
var logs_path = game_integration.get_game_logs_path(game_path)
var addons_path = game_integration.get_game_addons_path(game_path)
```

## Mobile-Specific Assets

### Touch Controls
- **Joystick Background**: Circular texture for joystick base
- **Joystick Handle**: Movable joystick control
- **Action Buttons**: Customizable action button textures

### Responsive Design
- **Scalable Textures**: Assets that scale well on different screen sizes
- **High DPI Support**: Assets optimized for high-resolution displays
- **Touch-Friendly Sizes**: Minimum 44x44 pixels for touch targets

### Platform-Specific Assets
- **Android**: Optimized for Android UI guidelines
- **iOS**: Follows iOS design principles
- **Desktop**: Standard desktop UI elements

## Performance Optimization

### Asset Loading Strategies
- **Lazy Loading**: Load assets only when needed
- **Preloading**: Preload essential assets on startup
- **Caching**: Efficient asset caching to reduce disk I/O
- **Memory Management**: Proper cleanup of unused assets

### Mobile Optimization
- **Texture Compression**: Optimized texture formats for mobile
- **Memory Usage**: Monitor and optimize memory usage
- **Battery Life**: Efficient asset loading to preserve battery

## Best Practices

### Asset Creation
1. **Use Consistent Sizing**: Power of 2 sizes for textures
2. **Optimize File Sizes**: Compress assets appropriately
3. **Maintain Quality**: Balance quality vs. file size
4. **Test on Target Platforms**: Verify assets work on all platforms

### Game Integration
1. **Validate Installations**: Always validate before using
2. **Handle Errors Gracefully**: Provide fallbacks for missing files
3. **Backup Configurations**: Always backup before modifying
4. **Cross-Platform Compatibility**: Test on all target platforms

### Mobile Considerations
1. **Touch-Friendly Design**: Ensure all interactive elements are touch-accessible
2. **Performance Monitoring**: Monitor performance on mobile devices
3. **Battery Optimization**: Minimize unnecessary asset loading
4. **Storage Management**: Be mindful of app size on mobile devices

## Troubleshooting

### Common Asset Issues
- **Missing Assets**: Check file paths and create placeholders
- **Format Issues**: Ensure assets are in supported formats
- **Memory Issues**: Monitor asset memory usage and cleanup

### Game Integration Issues
- **Installation Not Found**: Check common installation paths
- **Version Reading Failed**: Verify binary file integrity
- **Config Access Denied**: Check file permissions

### Mobile-Specific Issues
- **Touch Controls Not Working**: Verify touch input handling
- **Performance Problems**: Optimize asset loading and rendering
- **Display Issues**: Test on different screen sizes and resolutions