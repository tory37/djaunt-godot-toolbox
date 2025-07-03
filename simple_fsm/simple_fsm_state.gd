# SimpleFSMState - Base class for FSM states
#
# Inherit from this class to create custom states with their own logic.
# Use this for complex states that need their own methods and properties.
#
# For simple states with just enter/exit callbacks, use SimplerState instead.
#
# Example:
#   class MyCustomState extends SimpleFSMState:
#       func enter():
#           print("Entering custom state")
#           # Custom logic here
#       
#       func exit():
#           print("Exiting custom state")
#           # Cleanup logic here

class_name SimpleFSMState

func enter():
	pass

func exit():
	pass
