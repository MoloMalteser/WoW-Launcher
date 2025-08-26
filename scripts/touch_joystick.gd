extends Control

signal joystick_moved(direction: Vector2)
signal joystick_released()

@onready var background = $JoystickBackground
@onready var handle = $JoystickHandle

var joystick_center: Vector2
var joystick_radius: float = 50.0
var is_active: bool = false
var deadzone: float = 0.1
var max_distance: float = 50.0

# Visual feedback
var original_handle_color: Color
var active_handle_color: Color = Color(0.6, 0.6, 0.6, 1.0)
var original_bg_color: Color
var active_bg_color: Color = Color(0.3, 0.3, 0.3, 0.9)

func _ready():
	# Store original colors
	if handle:
		original_handle_color = handle.color
	if background:
		original_bg_color = background.color
	
	# Setup joystick
	joystick_center = size / 2
	_reset_joystick()
	
	# Connect input events
	gui_input.connect(_on_joystick_input)

func _on_joystick_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			_activate_joystick(event.position)
		else:
			_deactivate_joystick()
	
	elif event is InputEventScreenDrag and is_active:
		_update_joystick_position(event.position)

func _activate_joystick(touch_pos: Vector2):
	is_active = true
	_update_joystick_position(touch_pos)
	_update_visual_feedback(true)

func _deactivate_joystick():
	is_active = false
	_reset_joystick()
	_update_visual_feedback(false)
	joystick_released.emit()

func _update_joystick_position(touch_pos: Vector2):
	var local_pos = to_local(touch_pos)
	var direction = local_pos - joystick_center
	var distance = direction.length()
	
	# Clamp to max distance
	if distance > max_distance:
		direction = direction.normalized() * max_distance
		distance = max_distance
	
	# Apply deadzone
	var normalized_distance = distance / max_distance
	if normalized_distance < deadzone:
		direction = Vector2.ZERO
		normalized_distance = 0.0
	
	# Update handle position
	if handle:
		handle.position = joystick_center + direction - handle.size / 2
	
	# Emit joystick signal
	var input_vector = direction / max_distance
	joystick_moved.emit(input_vector)
	
	# Update input actions
	_update_input_actions(input_vector)

func _reset_joystick():
	if handle:
		handle.position = joystick_center - handle.size / 2
	
	# Clear input actions
	_clear_input_actions()

func _update_visual_feedback(active: bool):
	if handle:
		handle.color = active_handle_color if active else original_handle_color
	if background:
		background.color = active_bg_color if active else original_bg_color

func _update_input_actions(input_vector: Vector2):
	# Map joystick input to Godot input actions
	if abs(input_vector.x) > deadzone:
		if input_vector.x < 0:
			Input.action_press("ui_left", abs(input_vector.x))
			Input.action_release("ui_right")
		else:
			Input.action_press("ui_right", abs(input_vector.x))
			Input.action_release("ui_left")
	else:
		Input.action_release("ui_left")
		Input.action_release("ui_right")
	
	if abs(input_vector.y) > deadzone:
		if input_vector.y < 0:
			Input.action_press("ui_up", abs(input_vector.y))
			Input.action_release("ui_down")
		else:
			Input.action_press("ui_down", abs(input_vector.y))
			Input.action_release("ui_up")
	else:
		Input.action_release("ui_up")
		Input.action_release("ui_down")

func _clear_input_actions():
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")
	Input.action_release("ui_down")

func set_deadzone(value: float):
	deadzone = clamp(value, 0.0, 1.0)

func set_max_distance(value: float):
	max_distance = max(value, 10.0)
	joystick_radius = max_distance

func get_joystick_value() -> Vector2:
	if not is_active:
		return Vector2.ZERO
	
	var handle_pos = handle.position + handle.size / 2
	var direction = handle_pos - joystick_center
	var distance = direction.length()
	
	if distance < deadzone * max_distance:
		return Vector2.ZERO
	
	return direction / max_distance

func is_joystick_active() -> bool:
	return is_active