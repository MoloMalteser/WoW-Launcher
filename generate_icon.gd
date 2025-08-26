extends Node

# Simple script to generate the application icon
# Run this script to create the icon.png file

func _ready():
	print("Generating Arctium WoW Launcher icon...")
	
	# Create icon generator
	var icon_generator = preload("res://scripts/icon_generator.gd").new()
	add_child(icon_generator)
	
	# Generate the main icon
	icon_generator.generate_application_icon()
	
	# Generate platform-specific variants
	icon_generator.create_platform_icons()
	
	print("Icon generation complete!")
	print("Check the assets/ directory for generated icons.")
	
	# Exit after generation
	get_tree().quit()