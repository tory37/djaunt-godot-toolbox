extends Node
class_name SimpleFSM

var _current_state: SimpleFSMState = null
var _states: Dictionary = {}
var _state_enum: Dictionary = {}

func register_state(state_enum_value: int, state: SimpleFSMState) -> void:
	_states[state_enum_value] = state
	_state_enum[state] = state_enum_value

func go_to_state(state_enum_value: int) -> void:
	if _current_state:
		_current_state.exit()

	_current_state = _states[state_enum_value]
	_current_state.enter()

func get_current_state() -> SimpleFSMState:
	return _current_state

func get_current_state_name() -> String:
	if _current_state:
		return _get_state_name(_state_enum[_current_state])
	return "None"

func _get_state_name(state_enum_value: int) -> String:
	# This will be overridden by subclasses to provide meaningful state names
	return "State_%d" % state_enum_value
