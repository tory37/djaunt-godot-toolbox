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

class_name SimpleFSM

var _current_state: SimpleFSMState = null
var _states: Dictionary[String, SimpleFSMState] = {}
var _should_log: bool = false

func _init(should_log: bool = false) -> void:
	_should_log = should_log

func register_state(state_name: String, state: SimpleFSMState) -> void:
	_states[state_name] = state

func go_to_state(state_name: String) -> void:
	print("Going to state: ", state_name)
	if _current_state:
		if _should_log:
			print("Exiting state: ", get_current_state_name())
		_current_state.exit()

	_current_state = _states[state_name]

	if _should_log:
		print("Entering state: ", state_name)
	_current_state.enter()

func get_current_state() -> SimpleFSMState:
	return _current_state

func get_current_state_name() -> String:
	if _current_state:
		return _states.find_key(_current_state)
	return "None"
