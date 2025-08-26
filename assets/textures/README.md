# Textures Directory

This directory contains texture assets for the Arctium WoW Launcher.

## Required Textures

### UI Textures
- `background.png` - Main background texture (1280x720 recommended)
- `button_normal.png` - Normal button state texture
- `button_pressed.png` - Pressed button state texture
- `button_hover.png` - Hover button state texture

### Mobile Controls
- `joystick_bg.png` - Joystick background texture (circular, 100x100 recommended)
- `joystick_handle.png` - Joystick handle texture (circular, 40x40 recommended)
- `action_button.png` - Action button texture (60x60 recommended)

### Game Icons
- `game_retail.png` - Retail WoW icon (32x32)
- `game_classic.png` - Classic WoW icon (32x32)
- `game_classic_era.png` - Classic Era WoW icon (32x32)

### Status Icons
- `status_success.png` - Success status icon (16x16)
- `status_error.png` - Error status icon (16x16)
- `status_warning.png` - Warning status icon (16x16)
- `status_info.png` - Info status icon (16x16)

## Texture Requirements

### Format
- **Format**: PNG (preferred) or JPG
- **Color Depth**: 32-bit RGBA (for transparency support)
- **Compression**: Optimized for file size

### Sizes
- **UI Elements**: Power of 2 sizes (256x256, 512x512, etc.)
- **Icons**: 16x16, 32x32, 64x64
- **Backgrounds**: Match target resolution (1280x720, 1920x1080)

### Style Guidelines
- **Theme**: Dark theme compatible
- **Colors**: Use the launcher's color palette
- **Transparency**: Use alpha channel for rounded corners and shadows
- **Consistency**: Maintain visual consistency across all textures

## Adding New Textures

1. Create your texture in the required format and size
2. Place it in this directory
3. Update the asset manager to include the new texture
4. Test the texture in both desktop and mobile layouts

## Color Palette

Use these colors for consistency:
- **Primary**: #141414 (Dark background)
- **Secondary**: #2A2A2A (Panel background)
- **Accent**: #4A90E2 (Blue accent)
- **Text**: #FFFFFF (White text)
- **Text Secondary**: #B3B3B3 (Gray text)
- **Success**: #4CAF50 (Green)
- **Error**: #F44336 (Red)
- **Warning**: #FF9800 (Orange)