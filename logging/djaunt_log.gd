## DjauntLog
# A simple logging utility for Godot that provides controlled debug output.
#
# This class allows you to enable/disable logging at runtime and automatically
# prefixes log messages with a custom prefix for better debugging context.
#
# Usage:
# ```gdscript
# # Create a logger instance with a custom prefix
# var logger = DjauntLog.new("MyClass")
#
# # Enable/disable logging for this instance
# logger.enable()
# logger.disable()
#
# # Log messages (only shown when enabled)
# logger.log(["This is a debug message"])
# logger.log(["Multiple", "arguments", "like", "print()"])
# logger.log(["Any", "number", "of", "arguments", "is", "now", "supported", 42, true])
# # Output: [MyClass] This is a debug message
# # Output: [MyClass] Multiple arguments like print()
# # Output: [MyClass] Any number of arguments is now supported 42 true
# ```

class_name DjauntLog

var _enabled: bool = false
var _prefix: String
const _INDENT_SIZE: int = 2

func _init(enabled: bool = false, prefix: String = "") -> void:
	_enabled = enabled
	_prefix = prefix

func enable() -> void:
	_enabled = true

func disable() -> void:
	_enabled = false

func is_enabled() -> bool:
	return _enabled

func _format_value(value, indent_level: int = 0) -> String:
	var indent = " ".repeat(_INDENT_SIZE * indent_level)
	
	if value == null:
		return "null"
	
	match typeof(value):
		TYPE_DICTIONARY:
			if value.is_empty():
				return "{}"
			var items = []
			for key in value:
				items.append("%s%s: %s" % [
					indent + " ".repeat(_INDENT_SIZE),
					_format_value(key),
					_format_value(value[key], indent_level + 1)
				])
			return "{\n%s\n%s}" % ["\n".join(items), indent]
		
		TYPE_ARRAY:
			if value.is_empty():
				return "[]"
			var items = []
			for item in value:
				items.append("%s%s" % [
					indent + " ".repeat(_INDENT_SIZE),
					_format_value(item, indent_level + 1)
				])
			return "[\n%s\n%s]" % ["\n".join(items), indent]
		
		TYPE_OBJECT:
			if value is Resource:
				return "[Resource: %s]" % value.resource_path
			elif value is Node:
				return "[Node: %s]" % value.name
			else:
				return "[Object: %s]" % value.get_class()
		
		TYPE_STRING:
			return '"%s"' % value
		
		TYPE_BOOL:
			return "true" if value else "false"
		
		TYPE_FLOAT:
			return str(value) if value != int(value) else str(int(value))
		
		_:
			return str(value)

func log(messages: Array, force: bool = false) -> void:
	if _enabled or force:
		var formatted_messages = messages.map(func(arg): return _format_value(arg))
		var message = " ".join(formatted_messages)
		print("[%s] %s" % [_prefix, message])