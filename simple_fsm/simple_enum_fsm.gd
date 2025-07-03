extends SimpleFSM
class_name SimpleEnumFSM

var _state_enum: Dictionary = {}

func register_eum_state(state_enum_value: int, state: SimpleFSMState) -> void:
	_state_enum[state_enum_value] = state
	register_state(_state_enum[state_enum_value], state)


func go_to_enum_state(state_enum_value: int) -> void:
	super.go_to_state(_state_enum[state_enum_value])

func get_current_state_name() -> String:
	if _current_state:
		return _get_state_name(_state_enum[_current_state])
	return "None"

func _get_current_state_enum() -> int:
	return _state_enum[_current_state]

func _get_state_name(state_enum_value: int) -> String:
	# This should be overridden by subclasses to provide meaningful state names
	return "State_%d" % state_enum_value