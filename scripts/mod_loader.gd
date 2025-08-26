extends Node

signal mod_loaded(mod_name: String)
signal mod_load_failed(mod_name: String, error: String)
signal mapping_loaded(mapping_file: String, file_count: int)

var mappings_folder: String = "mappings"
var files_folder: String = "files"
var loaded_mappings: Dictionary = {}
var loaded_mods: Array[String] = []

func _ready():
	# Initialize mod loader
	pass

func load_mappings() -> bool:
	var mappings_path = mappings_folder
	if not DirAccess.dir_exists_absolute(mappings_path):
		# Try relative to executable
		mappings_path = OS.get_executable_path().get_base_dir().path_join(mappings_folder)
		if not DirAccess.dir_exists_absolute(mappings_path):
			print("Mappings folder not found: %s" % mappings_path)
			return false
	
	var dir = DirAccess.open(mappings_path)
	if not dir:
		print("Failed to open mappings directory: %s" % mappings_path)
		return false
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not file_name.begins_with(".") and file_name.ends_with(".txt"):
			var mapping_file = mappings_path.path_join(file_name)
			if _load_mapping_file(mapping_file):
				print("Loaded mapping: %s" % file_name)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return loaded_mappings.size() > 0

func _load_mapping_file(mapping_path: String) -> bool:
	if not FileAccess.file_exists(mapping_path):
		return false
	
	var file = FileAccess.open(mapping_path, FileAccess.READ)
	if not file:
		return false
	
	var mapping_name = mapping_path.get_file().get_basename()
	var file_mappings: Dictionary = {}
	var line_count = 0
	
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		
		var parts = line.split(";")
		if parts.size() >= 2:
			var file_id = parts[0]
			var file_path = parts[1]
			file_mappings[file_id] = file_path
			line_count += 1
	
	file.close()
	
	if file_mappings.size() > 0:
		loaded_mappings[mapping_name] = file_mappings
		mapping_loaded.emit(mapping_name, line_count)
		return true
	
	return false

func load_custom_files() -> bool:
	var files_path = files_folder
	if not DirAccess.dir_exists_absolute(files_path):
		# Try relative to executable
		files_path = OS.get_executable_path().get_base_dir().path_join(files_folder)
		if not DirAccess.dir_exists_absolute(files_path):
			print("Files folder not found: %s" % files_path)
			return false
	
	var dir = DirAccess.open(files_path)
	if not dir:
		print("Failed to open files directory: %s" % files_path)
		return false
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not file_name.begins_with("."):
			var file_path = files_path.path_join(file_name)
			if _load_custom_file(file_path):
				loaded_mods.append(file_name)
				mod_loaded.emit(file_name)
			else:
				mod_load_failed.emit(file_name, "Failed to load custom file")
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return loaded_mods.size() > 0

func _load_custom_file(file_path: String) -> bool:
	# This would implement the actual file loading logic
	# For now, just check if the file exists
	if FileAccess.file_exists(file_path):
		print("Custom file found: %s" % file_path)
		return true
	return false

func get_file_mapping(file_id: String) -> String:
	for mapping in loaded_mappings.values():
		if mapping.has(file_id):
			return mapping[file_id]
	return ""

func get_loaded_mods() -> Array[String]:
	return loaded_mods

func get_loaded_mappings() -> Dictionary:
	return loaded_mappings

func clear_loaded_mods():
	loaded_mods.clear()
	loaded_mappings.clear()

func is_mod_loaded(mod_name: String) -> bool:
	return loaded_mods.has(mod_name)

func get_mod_count() -> int:
	return loaded_mods.size()

func get_mapping_count() -> int:
	return loaded_mappings.size()