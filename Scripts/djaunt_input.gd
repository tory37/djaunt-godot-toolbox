## DjauntInput
# A flexible input management system for Godot that allows for dynamic input action registration and handling.
#
# Usage:
# 1. Create a new script that extends DjauntInput
# 2. Define an enum for your input actions (e.g. NewInputActions)
# 3. Register your actions in _init()
# 4. Add the script as an autoload/singleton in Project Settings
#

# func _init() -> void:
#     register_action(NewInputActions.MOVE_UP, "move_up")
#     register_action(NewInputActions.MOVE_DOWN, "move_down")
#     # ... register other actions
# ```
#
# To set up as an autoload/singleton:
# 1. Go to Project Settings -> Autoload
# 2. Add your input script (e.g., NewInputActions.gd)
# 3. Set the Node Name (e.g., "NewInputActions")
# 4. Enable "Enable" checkbox
#
# Then you can access your input system globally:
# ```gdscript
# NewInputActions.is_moving_up()  # Example from NewInputActions
# ```

class_name DjauntInput
extends Node

var Logger = DjauntLog.new(false)

# Dictionary to store registered action mappings
var _action_mappings = {}

# Register a new input action with its corresponding string
func register_action(action_id, action_string: String) -> void:
	Logger.log("Registering action: " + str(action_id) + " with string: " + action_string)
	_action_mappings[action_id] = action_string

# Get the string value for an action ID
func get_action_string(action_id) -> String:
	if not _action_mappings.has(action_id):
		Logger.log("Input action not registered: " + str(action_id))
		return ""
	return _action_mappings[action_id]

# Check if an action is currently pressed
func is_action_pressed(action_id) -> bool:
	Logger.log("Checking if action is pressed: " + str(action_id))
	var action_string = get_action_string(action_id)
	Logger.log("Action string: " + action_string)
	if action_string == "":
		Logger.log("Action string is empty")
		return false
	Logger.log("Action string is not empty")
	return Input.is_action_pressed(action_string)

func get_action_strength(action_id) -> float:
	var action_string = get_action_string(action_id)
	if action_string == "":
		return 0.0
	return Input.get_action_strength(action_string)

# Check if an action was just pressed
func is_action_just_pressed(action_id) -> bool:
	var action_string = get_action_string(action_id)
	if action_string == "":
		return false
	return Input.is_action_just_pressed(action_string)

# Check if an action was just released
func is_action_just_released(action_id) -> bool:
	var action_string = get_action_string(action_id)
	if action_string == "":
		return false
	return Input.is_action_just_released(action_string)

# Log all registered input states for debugging
func log_input_states() -> void:
	Logger.log("=== INPUT STATES ===")
	for action_id in _action_mappings.keys():
		var action_string = _action_mappings[action_id]
		Logger.log(action_string + ": " + str(is_action_pressed(action_id)))
	Logger.log("===================")
