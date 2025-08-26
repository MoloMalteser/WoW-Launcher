extends Node

enum GameVersion {
	RETAIL,
	CLASSIC,
	CLASSIC_ERA
}

enum GameBuild {
	RETAIL_MIN = 37862,
	CLASSIC_MIN = 39926,
	CLASSIC_ERA_MIN = 40347
}

signal game_launched()
signal game_launch_failed(error_message: String)
signal certificate_validated()
signal certificate_validation_failed(error_message: String)

var current_game_version: GameVersion = GameVersion.RETAIL
var game_binary_path: String = ""
var game_folder: String = ""
var dev_mode_enabled: bool = false
var keep_cache: bool = true
var use_static_auth_seed: bool = false
var skip_connection_patching: bool = false

var ip_filter: Array[String] = [
	"0.0.0.0/8",
	"10.0.0.0/8", 
	"100.64.0.0/10",
	"127.0.0.0/8",
	"169.254.0.0/16",
	"172.16.0.0/12",
	"192.0.0.0/24",
	"192.0.0.0/29",
	"192.0.0.8/32",
	"192.0.0.9/32",
	"192.0.0.170/32",
	"192.0.0.171/32",
	"192.0.2.0/24",
	"192.31.196.0/24",
	"192.52.193.0/24",
	"192.88.99.0/24",
	"192.168.0.0/16",
	"192.175.48.0/24",
	"198.18.0.0/15",
	"198.51.100.0/24",
	"203.0.113.0/24",
	"240.0.0.0/4",
	"255.255.255.255/32"
]

func _ready():
	# Initialize launcher
	pass

func set_game_version(version: GameVersion):
	current_game_version = version

func get_game_version_info() -> Dictionary:
	match current_game_version:
		GameVersion.RETAIL:
			return {
				"sub_folder": "_retail_",
				"binary_name": "Wow.exe",
				"major_versions": [9, 10],
				"min_build": GameBuild.RETAIL_MIN
			}
		GameVersion.CLASSIC:
			return {
				"sub_folder": "_classic_", 
				"binary_name": "WowClassic.exe",
				"major_versions": [2, 3],
				"min_build": GameBuild.CLASSIC_MIN
			}
		GameVersion.CLASSIC_ERA:
			return {
				"sub_folder": "_classic_era_",
				"binary_name": "WowClassic.exe", 
				"major_versions": [1],
				"min_build": GameBuild.CLASSIC_ERA_MIN
			}
		_:
			return {}

func prepare_game_launch(custom_game_path: String = "") -> bool:
	var version_info = get_game_version_info()
	if version_info.is_empty():
		game_launch_failed.emit("Invalid game version specified")
		return false
	
	var current_folder = OS.get_executable_path().get_base_dir()
	var sub_folder = version_info.sub_folder
	var binary_name = version_info.binary_name
	var min_build = version_info.min_build
	
	# Determine game folder
	if custom_game_path != "":
		game_folder = custom_game_path
	else:
		game_folder = current_folder.path_join(sub_folder)
	
	game_binary_path = game_folder.path_join(binary_name)
	
	# Check if binary exists in subfolder, if not try root folder
	if not FileAccess.file_exists(game_binary_path):
		game_folder = current_folder
		game_binary_path = game_folder.path_join(binary_name)
	
	if not FileAccess.file_exists(game_binary_path):
		game_launch_failed.emit("No %s client found at %s" % [get_version_name(), game_binary_path])
		return false
	
	# Validate game version
	var client_version = get_version_from_binary(game_binary_path)
	if client_version == null:
		game_launch_failed.emit("Could not read version from game binary")
		return false
	
	var major_version = client_version.major
	if not version_info.major_versions.has(major_version):
		game_launch_failed.emit("Invalid major version %d for %s" % [major_version, get_version_name()])
		return false
	
	var build = client_version.build
	if build < min_build and build != 0:
		game_launch_failed.emit("Client build %d is not supported. Minimum required: %d" % [build, min_build])
		return false
	
	# Clear cache if requested
	if not keep_cache:
		clear_cache()
	
	return true

func get_version_name() -> String:
	match current_game_version:
		GameVersion.RETAIL:
			return "Retail"
		GameVersion.CLASSIC:
			return "Classic"
		GameVersion.CLASSIC_ERA:
			return "Classic Era"
		_:
			return "Unknown"

func get_version_from_binary(binary_path: String) -> Dictionary:
	# This would need to be implemented to read the actual version from the binary
	# For now, return a mock version
	return {
		"major": 10,
		"minor": 1,
		"build": 50000,
		"revision": 0
	}

func clear_cache():
	var cache_path = game_folder.path_join("Cache")
	if DirAccess.dir_exists_absolute(cache_path):
		var dir = DirAccess.open(cache_path)
		if dir:
			dir.remove_recursive(cache_path)

func validate_certificate(hostname: String, port: int) -> bool:
	if dev_mode_enabled:
		return true
	
	# In a real implementation, this would validate SSL certificates
	# For now, we'll simulate the validation
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# This is a simplified version - in reality you'd need proper SSL validation
	var url = "https://%s:%d" % [hostname, port]
	var error = http_request.request(url)
	
	if error != OK:
		certificate_validation_failed.emit("Failed to connect to %s:%d" % [hostname, port])
		return false
	
	# In a real implementation, you'd check the SSL certificate here
	certificate_validated.emit()
	return true

func launch_game(command_line_args: String = "") -> bool:
	if game_binary_path.is_empty():
		game_launch_failed.emit("No game binary path set")
		return false
	
	if not FileAccess.file_exists(game_binary_path):
		game_launch_failed.emit("Game binary not found: %s" % game_binary_path)
		return false
	
	# Build command line
	var args = []
	if command_line_args != "":
		args.append_array(command_line_args.split(" "))
	
	# Add config parameter
	args.append("-config")
	args.append("Config.wtf")
	
	# Launch the game
	var output = []
	var exit_code = OS.execute(game_binary_path, args, output, true)
	
	if exit_code == 0:
		game_launched.emit()
		return true
	else:
		game_launch_failed.emit("Failed to launch game (exit code: %d)" % exit_code)
		return false

func is_dev_mode_allowed(ip_address: String) -> bool:
	# Check if IP is in private ranges
	for cidr in ip_filter:
		if is_ip_in_cidr(ip_address, cidr):
			return true
	return false

func is_ip_in_cidr(ip: String, cidr: String) -> bool:
	# Simplified CIDR check - in reality you'd need proper IP parsing
	var parts = cidr.split("/")
	if parts.size() != 2:
		return false
	
	var network = parts[0]
	var mask_bits = int(parts[1])
	
	# This is a simplified implementation
	# In reality you'd need proper IP address parsing and bitwise operations
	return ip.begins_with(network.split(".")[0] + ".")

func set_dev_mode(enabled: bool):
	dev_mode_enabled = enabled

func set_keep_cache(keep: bool):
	keep_cache = keep

func set_static_auth_seed(use: bool):
	use_static_auth_seed = use

func set_skip_connection_patching(skip: bool):
	skip_connection_patching = skip