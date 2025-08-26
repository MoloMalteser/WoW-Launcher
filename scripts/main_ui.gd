extends Control

@onready var game_version_option = $VBoxContainer/Content/LeftPanel/GameVersionGroup/GameVersionOptionButton
@onready var game_path_edit = $VBoxContainer/Content/LeftPanel/GamePathGroup/GamePathHBox/GamePathLineEdit
@onready var browse_button = $VBoxContainer/Content/LeftPanel/GamePathGroup/GamePathHBox/BrowseButton
@onready var dev_mode_checkbox = $VBoxContainer/Content/LeftPanel/OptionsGroup/DevModeCheckBox
@onready var keep_cache_checkbox = $VBoxContainer/Content/LeftPanel/OptionsGroup/KeepCacheCheckBox
@onready var static_auth_seed_checkbox = $VBoxContainer/Content/LeftPanel/OptionsGroup/StaticAuthSeedCheckBox
@onready var skip_patching_checkbox = $VBoxContainer/Content/LeftPanel/OptionsGroup/SkipPatchingCheckBox
@onready var status_text = $VBoxContainer/Content/RightPanel/StatusGroup/StatusTextEdit
@onready var launch_button = $VBoxContainer/Content/RightPanel/LaunchButton
@onready var mobile_controls = $MobileControls
@onready var touch_joystick = $MobileControls/TouchJoystick
@onready var joystick_handle = $MobileControls/TouchJoystick/JoystickHandle
@onready var launcher = $Launcher

var is_mobile: bool = false
var joystick_center: Vector2
var joystick_radius: float = 50.0
var joystick_active: bool = false

func _ready():
	# Connect launcher signals
	launcher.game_launched.connect(_on_game_launched)
	launcher.game_launch_failed.connect(_on_game_launch_failed)
	launcher.certificate_validated.connect(_on_certificate_validated)
	launcher.certificate_validation_failed.connect(_on_certificate_validation_failed)
	
	# Connect UI signals
	game_version_option.item_selected.connect(_on_game_version_changed)
	browse_button.pressed.connect(_on_browse_pressed)
	dev_mode_checkbox.toggled.connect(_on_dev_mode_toggled)
	keep_cache_checkbox.toggled.connect(_on_keep_cache_toggled)
	static_auth_seed_checkbox.toggled.connect(_on_static_auth_seed_toggled)
	skip_patching_checkbox.toggled.connect(_on_skip_patching_toggled)
	launch_button.pressed.connect(_on_launch_pressed)
	
	# Detect mobile platform
	_detect_mobile_platform()
	
	# Setup mobile controls if needed
	if is_mobile:
		_setup_mobile_controls()
	
	# Initialize launcher settings
	_update_launcher_settings()
	
	# Add initial status message
	_add_status_message("Arctium WoW Launcher initialized")
	_add_status_message("Select game version and options, then click Launch Game")

func _detect_mobile_platform():
	# Check if running on mobile platform
	is_mobile = OS.get_name() in ["Android", "iOS"]
	
	if is_mobile:
		# Show mobile controls
		mobile_controls.visible = true
		_add_status_message("Mobile platform detected - touch controls enabled")
	else:
		# Hide mobile controls on desktop
		mobile_controls.visible = false

func _setup_mobile_controls():
	# Setup touch joystick
	joystick_center = touch_joystick.size / 2
	
	# Connect touch events
	touch_joystick.gui_input.connect(_on_joystick_input)
	
	# Setup action buttons
	var action_button1 = $MobileControls/ActionButtons/ActionButton1
	var action_button2 = $MobileControls/ActionButtons/ActionButton2
	
	action_button1.pressed.connect(_on_action_button1_pressed)
	action_button2.pressed.connect(_on_action_button2_pressed)

func _on_joystick_input(event):
	if not is_mobile:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			joystick_active = true
			_update_joystick_position(event.position)
		else:
			joystick_active = false
			_reset_joystick()
	
	elif event is InputEventScreenDrag and joystick_active:
		_update_joystick_position(event.position)

func _update_joystick_position(touch_pos: Vector2):
	var local_pos = touch_joystick.to_local(touch_pos)
	var direction = local_pos - joystick_center
	var distance = direction.length()
	
	if distance > joystick_radius:
		direction = direction.normalized() * joystick_radius
	
	joystick_handle.position = joystick_center + direction - joystick_handle.size / 2
	
	# Emit joystick input
	var input_vector = direction / joystick_radius
	Input.action_press("ui_left", -input_vector.x)
	Input.action_press("ui_right", input_vector.x)
	Input.action_press("ui_up", -input_vector.y)
	Input.action_press("ui_down", input_vector.y)

func _reset_joystick():
	joystick_handle.position = joystick_center - joystick_handle.size / 2
	
	# Release joystick input
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")
	Input.action_release("ui_down")

func _on_action_button1_pressed():
	_add_status_message("Action Button 1 pressed")

func _on_action_button2_pressed():
	_add_status_message("Action Button 2 pressed")

func _on_game_version_changed(index: int):
	var version_map = {
		0: launcher.GameVersion.RETAIL,
		1: launcher.GameVersion.CLASSIC,
		2: launcher.GameVersion.CLASSIC_ERA
	}
	
	if version_map.has(index):
		launcher.set_game_version(version_map[index])
		_add_status_message("Game version changed to: %s" % launcher.get_version_name())

func _on_browse_pressed():
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	dialog.title = "Select WoW Game Directory"
	
	add_child(dialog)
	dialog.dir_selected.connect(_on_directory_selected)
	dialog.popup_centered()

func _on_directory_selected(path: String):
	game_path_edit.text = path
	_add_status_message("Game path set to: %s" % path)

func _on_dev_mode_toggled(button_pressed: bool):
	launcher.set_dev_mode(button_pressed)
	_add_status_message("Developer mode: %s" % ("Enabled" if button_pressed else "Disabled"))

func _on_keep_cache_toggled(button_pressed: bool):
	launcher.set_keep_cache(button_pressed)
	_add_status_message("Keep cache: %s" % ("Enabled" if button_pressed else "Disabled"))

func _on_static_auth_seed_toggled(button_pressed: bool):
	launcher.set_static_auth_seed(button_pressed)
	_add_status_message("Static auth seed: %s" % ("Enabled" if button_pressed else "Disabled"))

func _on_skip_patching_toggled(button_pressed: bool):
	launcher.set_skip_connection_patching(button_pressed)
	_add_status_message("Skip connection patching: %s" % ("Enabled" if button_pressed else "Disabled"))

func _on_launch_pressed():
	launch_button.disabled = true
	_add_status_message("Preparing to launch game...")
	
	# Update launcher settings
	_update_launcher_settings()
	
	# Prepare game launch
	var custom_path = game_path_edit.text if game_path_edit.text != "" else ""
	
	if launcher.prepare_game_launch(custom_path):
		_add_status_message("Game preparation successful")
		_add_status_message("Launching game...")
		
		# Launch the game
		if launcher.launch_game():
			_add_status_message("Game launched successfully!")
		else:
			_add_status_message("Failed to launch game")
	else:
		_add_status_message("Game preparation failed")
	
	launch_button.disabled = false

func _update_launcher_settings():
	# Update all launcher settings based on UI state
	launcher.set_dev_mode(dev_mode_checkbox.button_pressed)
	launcher.set_keep_cache(keep_cache_checkbox.button_pressed)
	launcher.set_static_auth_seed(static_auth_seed_checkbox.button_pressed)
	launcher.set_skip_connection_patching(skip_patching_checkbox.button_pressed)

func _on_game_launched():
	_add_status_message("Game launched successfully!")
	launch_button.disabled = false

func _on_game_launch_failed(error_message: String):
	_add_status_message("Game launch failed: %s" % error_message)
	launch_button.disabled = false

func _on_certificate_validated():
	_add_status_message("Server certificate validated successfully")

func _on_certificate_validation_failed(error_message: String):
	_add_status_message("Certificate validation failed: %s" % error_message)

func _add_status_message(message: String):
	var timestamp = Time.get_datetime_string_from_system()
	var formatted_message = "[%s] %s" % [timestamp, message]
	
	status_text.text += formatted_message + "\n"
	
	# Auto-scroll to bottom
	status_text.caret_line = status_text.get_line_count() - 1
	
	# Limit the number of lines to prevent memory issues
	var lines = status_text.text.split("\n")
	if lines.size() > 100:
		status_text.text = "\n".join(lines.slice(-50))

func _input(event):
	# Handle mobile-specific input
	if is_mobile and event is InputEventScreenTouch:
		# Handle general touch events
		pass
	
	# Handle keyboard shortcuts
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1:
				_add_status_message("F1 pressed - showing help")
			KEY_F5:
				_add_status_message("F5 pressed - refreshing status")
			KEY_ESCAPE:
				if is_mobile:
					# On mobile, ESC could toggle mobile controls
					mobile_controls.visible = !mobile_controls.visible