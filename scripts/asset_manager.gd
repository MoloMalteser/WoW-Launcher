extends Node

# Asset Manager
# Handles loading and management of game-related assets, textures, and UI elements

signal assets_loaded()
signal asset_load_failed(asset_name: String, error: String)

var loaded_assets: Dictionary = {}
var asset_cache: Dictionary = {}

# Asset paths
var asset_paths = {
	"icons": "res://assets/icons/",
	"textures": "res://assets/textures/",
	"fonts": "res://assets/fonts/",
	"sounds": "res://assets/sounds/",
	"themes": "res://assets/themes/"
}

# Default assets
var default_assets = {
	"icon": "res://assets/icon.png",
	"background": "res://assets/textures/background.png",
	"button_normal": "res://assets/textures/button_normal.png",
	"button_pressed": "res://assets/textures/button_pressed.png",
	"joystick_bg": "res://assets/textures/joystick_bg.png",
	"joystick_handle": "res://assets/textures/joystick_handle.png"
}

func _ready():
	load_default_assets()

func load_default_assets():
	# Load essential assets
	for asset_name in default_assets:
		var asset_path = default_assets[asset_name]
		if FileAccess.file_exists(asset_path):
			load_asset(asset_name, asset_path)
		else:
			# Create placeholder assets if they don't exist
			create_placeholder_asset(asset_name, asset_path)

func load_asset(asset_name: String, asset_path: String):
	if asset_cache.has(asset_name):
		return asset_cache[asset_name]
	
	if not FileAccess.file_exists(asset_path):
		asset_load_failed.emit(asset_name, "Asset file not found: " + asset_path)
		return null
	
	var extension = asset_path.get_extension().to_lower()
	var asset = null
	
	match extension:
		"png", "jpg", "jpeg":
			asset = load_texture(asset_path)
		"ttf", "otf":
			asset = load_font(asset_path)
		"ogg", "wav":
			asset = load_audio(asset_path)
		"tres", "res":
			asset = load_resource(asset_path)
		_:
			asset_load_failed.emit(asset_name, "Unsupported asset type: " + extension)
			return null
	
	if asset != null:
		asset_cache[asset_name] = asset
		loaded_assets[asset_name] = asset_path
		print("Loaded asset: ", asset_name, " from ", asset_path)
	
	return asset

func load_texture(path: String) -> Texture2D:
	var image = Image.new()
	var error = image.load(path)
	
	if error != OK:
		return null
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func load_font(path: String) -> FontFile:
	var font = FontFile.new()
	var error = font.load_dynamic_font(path)
	
	if error != OK:
		return null
	
	return font

func load_audio(path: String) -> AudioStream:
	var audio = AudioStreamOggVorbis.new()
	var error = audio.load_from_file(path)
	
	if error != OK:
		return null
	
	return audio

func load_resource(path: String) -> Resource:
	return load(path)

func create_placeholder_asset(asset_name: String, asset_path: String):
	# Create placeholder assets for missing files
	var placeholder = null
	
	if asset_name.contains("icon") or asset_name.contains("texture"):
		placeholder = create_placeholder_texture()
	elif asset_name.contains("font"):
		placeholder = create_placeholder_font()
	elif asset_name.contains("sound") or asset_name.contains("audio"):
		placeholder = create_placeholder_audio()
	
	if placeholder != null:
		asset_cache[asset_name] = placeholder
		loaded_assets[asset_name] = asset_path
		print("Created placeholder asset: ", asset_name)

func create_placeholder_texture() -> Texture2D:
	# Create a simple colored rectangle as placeholder
	var image = Image.new()
	image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.5, 0.5, 0.5, 1.0))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_placeholder_font() -> FontFile:
	# Return default font
	return ThemeDB.fallback_font

func create_placeholder_audio() -> AudioStream:
	# Create silent audio stream
	var audio = AudioStreamGenerator.new()
	audio.mix_rate = 44100
	return audio

func get_asset(asset_name: String):
	if asset_cache.has(asset_name):
		return asset_cache[asset_name]
	return null

func get_texture(asset_name: String) -> Texture2D:
	var asset = get_asset(asset_name)
	if asset is Texture2D:
		return asset
	return null

func get_font(asset_name: String) -> FontFile:
	var asset = get_asset(asset_name)
	if asset is FontFile:
		return asset
	return null

func get_audio(asset_name: String) -> AudioStream:
	var asset = get_asset(asset_name)
	if asset is AudioStream:
		return asset
	return null

func unload_asset(asset_name: String):
	if asset_cache.has(asset_name):
		asset_cache.erase(asset_name)
		loaded_assets.erase(asset_name)
		print("Unloaded asset: ", asset_name)

func unload_all_assets():
	asset_cache.clear()
	loaded_assets.clear()
	print("Unloaded all assets")

func get_loaded_assets() -> Dictionary:
	return loaded_assets.duplicate()

func get_asset_count() -> int:
	return asset_cache.size()

func is_asset_loaded(asset_name: String) -> bool:
	return asset_cache.has(asset_name)

func reload_asset(asset_name: String):
	if loaded_assets.has(asset_name):
		var asset_path = loaded_assets[asset_name]
		unload_asset(asset_name)
		load_asset(asset_name, asset_path)

func preload_assets(asset_list: Array):
	# Preload a list of assets
	for asset_name in asset_list:
		if default_assets.has(asset_name):
			load_asset(asset_name, default_assets[asset_name])

func create_game_icon(game_type: String) -> Texture2D:
	# Create a game-specific icon based on game type
	var image = Image.new()
	image.create(32, 32, false, Image.FORMAT_RGBA8)
	
	var color = Color.WHITE
	match game_type:
		"retail":
			color = Color.GOLD
		"classic":
			color = Color.ORANGE
		"classic_era":
			color = Color.YELLOW
		_:
			color = Color.GRAY
	
	image.fill(color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_status_icon(status: String) -> Texture2D:
	# Create status-specific icons
	var image = Image.new()
	image.create(16, 16, false, Image.FORMAT_RGBA8)
	
	var color = Color.WHITE
	match status:
		"success":
			color = Color.GREEN
		"error":
			color = Color.RED
		"warning":
			color = Color.YELLOW
		"info":
			color = Color.BLUE
		_:
			color = Color.GRAY
	
	image.fill(color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture