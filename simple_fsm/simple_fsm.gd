# SimpleFSM - Finite State Machine implementation
#
# A lightweight state machine that can work with both custom state classes
# and inline SimplerFSMState instances.
#
# Usage with custom state classes:
#   class IdleState extends SimpleFSMState:
#       func enter(): print("Entering idle")
#       func exit(): print("Exiting idle")
#
#   var fsm = SimpleFSM.new()
#   fsm.register_state(StateEnum.IDLE, IdleState.new())
#   fsm.go_to_state(StateEnum.IDLE)
#
# Usage with SimplerFSMState (inline states):
#   var fsm = SimpleFSM.new()
#   var idle_state = SimplerFSMState.new(
#       func(): print("Entering idle"),
#       func(): print("Exiting idle")
#   )
#   fsm.register_state(StateEnum.IDLE, idle_state)
#   fsm.go_to_state(StateEnum.IDLE)
#
# State enum example:
#   enum StateEnum { IDLE, WALK, RUN, JUMP }
#
# Override _get_state_name() in subclasses to provide meaningful state names
# for debugging and logging purposes.

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

func _get_current_state_enum() -> int:
	return _state_enum[_current_state]

func _get_state_name(state_enum_value: int) -> String:
	# This should be overridden by subclasses to provide meaningful state names
	return "State_%d" % state_enum_value
