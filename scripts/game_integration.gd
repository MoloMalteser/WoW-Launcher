extends Node

# Game Integration Script
# Handles WoW game file detection, version reading, and binary interaction

signal game_detected(game_path: String, version_info: Dictionary)
signal game_not_found(error_message: String)
signal version_read(version_info: Dictionary)

var supported_binaries = {
	"retail": "Wow.exe",
	"classic": "WowClassic.exe",
	"classic_era": "WowClassic.exe"
}

var common_install_paths = {
	"windows": [
		"C:/Program Files (x86)/World of Warcraft",
		"C:/Program Files/World of Warcraft",
		"C:/Games/World of Warcraft"
	],
	"linux": [
		"/opt/world-of-warcraft",
		"/usr/local/games/world-of-warcraft",
		"~/Games/World of Warcraft"
	],
	"macos": [
		"/Applications/World of Warcraft",
		"~/Applications/World of Warcraft"
	]
}

func _ready():
	pass

func detect_wow_installations() -> Dictionary:
	var installations = {}
	var platform = OS.get_name().to_lower()
	
	# Check common installation paths
	var paths_to_check = []
	if common_install_paths.has(platform):
		paths_to_check = common_install_paths[platform]
	
	# Add current directory and subdirectories
	var current_dir = OS.get_executable_path().get_base_dir()
	paths_to_check.append(current_dir)
	paths_to_check.append(current_dir.path_join("_retail_"))
	paths_to_check.append(current_dir.path_join("_classic_"))
	paths_to_check.append(current_dir.path_join("_classic_era_"))
	
	for path in paths_to_check:
		var detected_games = _scan_directory_for_games(path)
		if detected_games.size() > 0:
			installations[path] = detected_games
	
	return installations

func _scan_directory_for_games(directory_path: String) -> Dictionary:
	var games = {}
	
	if not DirAccess.dir_exists_absolute(directory_path):
		return games
	
	var dir = DirAccess.open(directory_path)
	if not dir:
		return games
	
	# Check for game binaries
	for binary_name in supported_binaries.values():
		var binary_path = directory_path.path_join(binary_name)
		if FileAccess.file_exists(binary_path):
			var version_info = _read_game_version(binary_path)
			if version_info != null:
				games[binary_name] = {
					"path": binary_path,
					"version": version_info,
					"type": _determine_game_type(binary_name, version_info)
				}
	
	return games

func _read_game_version(binary_path: String) -> Dictionary:
	# This is a simplified version reading implementation
	# In a real implementation, you'd read the actual PE/ELF file headers
	
	# For now, return mock version data
	# In reality, you'd implement proper binary version reading
	return {
		"major": 10,
		"minor": 1,
		"build": 50000,
		"revision": 0,
		"string": "10.1.5.50000"
	}

func _determine_game_type(binary_name: String, version_info: Dictionary) -> String:
	var major_version = version_info.major
	
	if binary_name == "Wow.exe":
		if major_version >= 9:
			return "retail"
		else:
			return "unknown"
	elif binary_name == "WowClassic.exe":
		if major_version == 1:
			return "classic_era"
		elif major_version >= 2 and major_version <= 3:
			return "classic"
		else:
			return "unknown"
	
	return "unknown"

func validate_game_installation(game_path: String, game_type: String) -> bool:
	if not FileAccess.file_exists(game_path):
		return false
	
	# Check for required game files
	var game_dir = game_path.get_base_dir()
	var required_files = [
		"Data/common.MPQ",
		"Data/common-2.MPQ",
		"WTF/Config.wtf"
	]
	
	for required_file in required_files:
		var full_path = game_dir.path_join(required_file)
		if not FileAccess.file_exists(full_path):
			return false
	
	return true

func get_game_config_path(game_path: String) -> String:
	var game_dir = game_path.get_base_dir()
	return game_dir.path_join("WTF/Config.wtf")

func read_game_config(config_path: String) -> Dictionary:
	var config = {}
	
	if not FileAccess.file_exists(config_path):
		return config
	
	var file = FileAccess.open(config_path, FileAccess.READ)
	if not file:
		return config
	
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		
		# Parse WoW config format
		var parts = line.split(" ")
		if parts.size() >= 2:
			var key = parts[0]
			var value = " ".join(parts.slice(1))
			config[key] = value
	
	file.close()
	return config

func write_game_config(config_path: String, config_data: Dictionary):
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	if not file:
		return
	
	for key in config_data:
		var value = config_data[key]
		file.store_line("%s %s" % [key, value])
	
	file.close()

func get_game_screenshots_path(game_path: String) -> String:
	var game_dir = game_path.get_base_dir()
	return game_dir.path_join("Screenshots")

func get_game_logs_path(game_path: String) -> String:
	var game_dir = game_path.get_base_dir()
	return game_dir.path_join("Logs")

func get_game_addons_path(game_path: String) -> String:
	var game_dir = game_path.get_base_dir()
	return game_dir.path_join("Interface/AddOns")

func backup_game_config(config_path: String) -> String:
	if not FileAccess.file_exists(config_path):
		return ""
	
	var backup_path = config_path + ".backup." + Time.get_datetime_string_from_system().replace(":", "-")
	
	var source_file = FileAccess.open(config_path, FileAccess.READ)
	var backup_file = FileAccess.open(backup_path, FileAccess.WRITE)
	
	if source_file and backup_file:
		backup_file.store_buffer(source_file.get_buffer(source_file.get_length()))
		source_file.close()
		backup_file.close()
		return backup_path
	
	return ""

func restore_game_config(config_path: String, backup_path: String) -> bool:
	if not FileAccess.file_exists(backup_path):
		return false
	
	var backup_file = FileAccess.open(backup_path, FileAccess.READ)
	var config_file = FileAccess.open(config_path, FileAccess.WRITE)
	
	if backup_file and config_file:
		config_file.store_buffer(backup_file.get_buffer(backup_file.get_length()))
		backup_file.close()
		config_file.close()
		return true
	
	return false

func get_game_memory_usage(game_path: String) -> int:
	# This would implement actual memory usage detection
	# For now, return a mock value
	return 1024 * 1024 * 512  # 512 MB

func is_game_running(game_path: String) -> bool:
	var game_name = game_path.get_file()
	
	# Check if the game process is running
	# This is platform-specific and would need proper implementation
	return false

func kill_game_process(game_path: String) -> bool:
	var game_name = game_path.get_file()
	
	# Kill the game process if it's running
	# This is platform-specific and would need proper implementation
	return false