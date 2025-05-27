## DjauntLog
# A simple logging utility for Godot that provides controlled debug output.
#
# This class allows you to enable/disable logging at runtime and automatically
# prefixes log messages with the script name for better debugging context.
#
# Usage:
# ```gdscript
# # Log messages (only shown when enabled)
# DjauntLog.log("This is a debug message")
# # Output: [DjauntLog] This is a debug message
#
# # Enable/disable logging
# DjauntLog.enable()
# DjauntLog.disable()
# ```

extends Node

var _enabled: bool = false

func _init() -> void:
	_enabled = false

func enable() -> void:
	_enabled = true

func disable() -> void:
	_enabled = false

func is_enabled() -> bool:
	return _enabled

func log(message: String) -> void:
	if _enabled:
		print("[%s] %s" % [get_script().resource_path.get_file().get_basename(), message])