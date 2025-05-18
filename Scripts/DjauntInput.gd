class_name DjauntInput
extends Node

# Dictionary to store registered action mappings
var _action_mappings = {}

# Register a new input action with its corresponding string
func register_action(action_id, action_string: String) -> void:
  _action_mappings[action_id] = action_string

# Get the string value for an action ID
func get_action_string(action_id) -> String:
  if not _action_mappings.has(action_id):
    push_error("Input action not registered: " + str(action_id))
    return ""
  return _action_mappings[action_id]

# Check if an action is currently pressed
func is_action_pressed(action_id) -> bool:
  var action_string = get_action_string(action_id)
  if action_string.empty():
    return false
  return Input.is_action_pressed(action_string)

# Check if an action was just pressed
func is_action_just_pressed(action_id) -> bool:
  var action_string = get_action_string(action_id)
  if action_string.empty():
    return false
  return Input.is_action_just_pressed(action_string)

# Check if an action was just released
func is_action_just_released(action_id) -> bool:
  var action_string = get_action_string(action_id)
  if action_string.empty():
    return false
  return Input.is_action_just_released(action_string)

# Log all registered input states for debugging
func log_input_states() -> void:
  print("=== INPUT STATES ===")
  for action_id in _action_mappings.keys():
    var action_string = _action_mappings[action_id]
    print(action_string, ": ", is_action_pressed(action_id))
  print("===================")