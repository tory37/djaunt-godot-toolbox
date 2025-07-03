# SimplerState - Lightweight FSM state for simple state machines
# 
# Use this class when you want to create states inline without separate class files.
# Perfect for simple states that can be defined with just enter/exit callbacks.
#
# Example usage:
#   var idle_state = SimplerState.new(
#       func(): print("Entering idle"),  # on_enter callback
#       func(): print("Exiting idle")    # on_exit callback
#   )
#   
#   var walk_state = SimplerState.new(
#       func(): print("Entering walk"),
#       func(): print("Exiting walk")
#   )
#
#   fsm.register_state(StateEnum.IDLE, idle_state)
#   fsm.register_state(StateEnum.WALK, walk_state)
#
# For complex states that need their own logic, inherit from SimpleFSMState instead.

extends SimpleFSMState
class_name SimplerFSMState

var _on_enter: Callable
var _on_exit: Callable

func _init(on_enter: Callable = Callable(), on_exit: Callable = Callable()):
	_on_enter = on_enter
	_on_exit = on_exit

func enter():
	if _on_enter.is_valid():
		_on_enter.call()

func exit():
	if _on_exit.is_valid():
		_on_exit.call()
