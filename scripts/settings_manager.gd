extends Node

signal settings_changed(setting_name: String, value: Variant)

# Mobile-specific settings
var mobile_settings: Dictionary = {
	"joystick_deadzone": 0.1,
	"joystick_sensitivity": 1.0,
	"joystick_size": 100.0,
	"action_button_size": 60.0,
	"ui_scale": 1.0,
	"touch_sensitivity": 1.0,
	"vibration_enabled": true,
	"sound_enabled": true,
	"auto_hide_controls": false,
	"show_touch_indicators": true
}

# General launcher settings
var launcher_settings: Dictionary = {
	"last_game_version": 0,
	"last_game_path": "",
	"dev_mode_enabled": false,
	"keep_cache_enabled": true,
	"static_auth_seed_enabled": false,
	"skip_patching_enabled": false,
	"auto_launch": false,
	"minimize_to_tray": false,
	"check_updates": true,
	"log_level": "INFO"
}

# File paths
var settings_file: String = "user://settings.cfg"

func _ready():
	load_settings()

func save_settings():
	var config = ConfigFile.new()
	
	# Save launcher settings
	for key in launcher_settings:
		config.set_value("launcher", key, launcher_settings[key])
	
	# Save mobile settings
	for key in mobile_settings:
		config.set_value("mobile", key, mobile_settings[key])
	
	config.save(settings_file)

func load_settings():
	var config = ConfigFile.new()
	var error = config.load(settings_file)
	
	if error != OK:
		# Create default settings
		create_default_settings()
		return
	
	# Load launcher settings
	for key in launcher_settings:
		if config.has_section_key("launcher", key):
			launcher_settings[key] = config.get_value("launcher", key, launcher_settings[key])
	
	# Load mobile settings
	for key in mobile_settings:
		if config.has_section_key("mobile", key):
			mobile_settings[key] = config.get_value("mobile", key, mobile_settings[key])

func create_default_settings():
	# Set default values
	mobile_settings = {
		"joystick_deadzone": 0.1,
		"joystick_sensitivity": 1.0,
		"joystick_size": 100.0,
		"action_button_size": 60.0,
		"ui_scale": 1.0,
		"touch_sensitivity": 1.0,
		"vibration_enabled": true,
		"sound_enabled": true,
		"auto_hide_controls": false,
		"show_touch_indicators": true
	}
	
	launcher_settings = {
		"last_game_version": 0,
		"last_game_path": "",
		"dev_mode_enabled": false,
		"keep_cache_enabled": true,
		"static_auth_seed_enabled": false,
		"skip_patching_enabled": false,
		"auto_launch": false,
		"minimize_to_tray": false,
		"check_updates": true,
		"log_level": "INFO"
	}
	
	save_settings()

func get_mobile_setting(key: String, default_value = null):
	if mobile_settings.has(key):
		return mobile_settings[key]
	return default_value

func set_mobile_setting(key: String, value):
	if mobile_settings.has(key):
		mobile_settings[key] = value
		settings_changed.emit(key, value)
		save_settings()

func get_launcher_setting(key: String, default_value = null):
	if launcher_settings.has(key):
		return launcher_settings[key]
	return default_value

func set_launcher_setting(key: String, value):
	if launcher_settings.has(key):
		launcher_settings[key] = value
		settings_changed.emit(key, value)
		save_settings()

# Mobile-specific helper functions
func get_joystick_deadzone() -> float:
	return get_mobile_setting("joystick_deadzone", 0.1)

func set_joystick_deadzone(value: float):
	set_mobile_setting("joystick_deadzone", clamp(value, 0.0, 1.0))

func get_joystick_sensitivity() -> float:
	return get_mobile_setting("joystick_sensitivity", 1.0)

func set_joystick_sensitivity(value: float):
	set_mobile_setting("joystick_sensitivity", clamp(value, 0.1, 3.0))

func get_joystick_size() -> float:
	return get_mobile_setting("joystick_size", 100.0)

func set_joystick_size(value: float):
	set_mobile_setting("joystick_size", clamp(value, 50.0, 200.0))

func get_action_button_size() -> float:
	return get_mobile_setting("action_button_size", 60.0)

func set_action_button_size(value: float):
	set_mobile_setting("action_button_size", clamp(value, 30.0, 120.0))

func get_ui_scale() -> float:
	return get_mobile_setting("ui_scale", 1.0)

func set_ui_scale(value: float):
	set_mobile_setting("ui_scale", clamp(value, 0.5, 2.0))

func is_vibration_enabled() -> bool:
	return get_mobile_setting("vibration_enabled", true)

func set_vibration_enabled(enabled: bool):
	set_mobile_setting("vibration_enabled", enabled)

func is_sound_enabled() -> bool:
	return get_mobile_setting("sound_enabled", true)

func set_sound_enabled(enabled: bool):
	set_mobile_setting("sound_enabled", enabled)

func is_auto_hide_controls() -> bool:
	return get_mobile_setting("auto_hide_controls", false)

func set_auto_hide_controls(enabled: bool):
	set_mobile_setting("auto_hide_controls", enabled)

func is_show_touch_indicators() -> bool:
	return get_mobile_setting("show_touch_indicators", true)

func set_show_touch_indicators(enabled: bool):
	set_mobile_setting("show_touch_indicators", enabled)

# Launcher-specific helper functions
func get_last_game_version() -> int:
	return get_launcher_setting("last_game_version", 0)

func set_last_game_version(version: int):
	set_launcher_setting("last_game_version", version)

func get_last_game_path() -> String:
	return get_launcher_setting("last_game_path", "")

func set_last_game_path(path: String):
	set_launcher_setting("last_game_path", path)

func is_dev_mode_enabled() -> bool:
	return get_launcher_setting("dev_mode_enabled", false)

func set_dev_mode_enabled(enabled: bool):
	set_launcher_setting("dev_mode_enabled", enabled)

func is_keep_cache_enabled() -> bool:
	return get_launcher_setting("keep_cache_enabled", true)

func set_keep_cache_enabled(enabled: bool):
	set_launcher_setting("keep_cache_enabled", enabled)

func is_static_auth_seed_enabled() -> bool:
	return get_launcher_setting("static_auth_seed_enabled", false)

func set_static_auth_seed_enabled(enabled: bool):
	set_launcher_setting("static_auth_seed_enabled", enabled)

func is_skip_patching_enabled() -> bool:
	return get_launcher_setting("skip_patching_enabled", false)

func set_skip_patching_enabled(enabled: bool):
	set_launcher_setting("skip_patching_enabled", enabled)

func is_auto_launch() -> bool:
	return get_launcher_setting("auto_launch", false)

func set_auto_launch(enabled: bool):
	set_launcher_setting("auto_launch", enabled)

func is_minimize_to_tray() -> bool:
	return get_launcher_setting("minimize_to_tray", false)

func set_minimize_to_tray(enabled: bool):
	set_launcher_setting("minimize_to_tray", enabled)

func is_check_updates() -> bool:
	return get_launcher_setting("check_updates", true)

func set_check_updates(enabled: bool):
	set_launcher_setting("check_updates", enabled)

func get_log_level() -> String:
	return get_launcher_setting("log_level", "INFO")

func set_log_level(level: String):
	set_launcher_setting("log_level", level)

# Utility functions
func reset_to_defaults():
	create_default_settings()

func export_settings() -> Dictionary:
	return {
		"mobile": mobile_settings.duplicate(),
		"launcher": launcher_settings.duplicate()
	}

func import_settings(settings_data: Dictionary):
	if settings_data.has("mobile"):
		mobile_settings = settings_data.mobile
	if settings_data.has("launcher"):
		launcher_settings = settings_data.launcher
	save_settings()