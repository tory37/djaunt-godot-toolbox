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