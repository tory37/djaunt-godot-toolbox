## DjauntLog
# A simple logging utility for Godot that provides controlled debug output.
#
# This class allows you to enable/disable logging at runtime and automatically
# prefixes log messages with the script name for better debugging context.
#
# Usage:
# ```gdscript
# # Create a new logger instance (disabled by default)
# var logger = DjauntLog.new()
#
# # Enable logging
# logger.enable()
#
# # Log messages (only shown when enabled)
# logger.log("This is a debug message")
# # Output: [DjauntLog] This is a debug message
#
# # Disable logging
# logger.disable()
# ```
#
# You can also create an enabled logger directly:
# ```gdscript
# var logger = DjauntLog.new(true)  # Enabled by default
# ```

class_name DjauntLog
extends RefCounted

var _enabled: bool

func _init(enabled: bool = false) -> void:
	_enabled = enabled

func enable() -> void:
	_enabled = true

func disable() -> void:
	_enabled = false

func is_enabled() -> bool:
	return _enabled

func log(message: String) -> void:
	if _enabled:
		print("[%s] %s" % [get_script().resource_path.get_file().get_basename(), message])