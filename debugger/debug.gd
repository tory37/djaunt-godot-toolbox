extends RefCounted
class_name DjauntDebug

var _enabled: bool = false
var _prefix: String = ""

func set_prefix(prefix: String) -> void:
	_prefix = prefix

func set_enabled(should_enable: bool = true) -> void:
	_enabled = should_enable

func is_enabled() -> bool:
	return _enabled

func print(messages: Variant) -> void:
	_process_messages(messages)

func print_debug(messages: Variant) -> void:
	if _enabled:
		if messages is String:
			print_debug(_format_message(messages))
		elif messages is Array:
			for msg in messages:
				if msg is String:
					print_debug(_format_message(msg))

func print_error(messages: Variant) -> void:
	if _enabled:
		if messages is String:
			push_error(_format_message(messages))
		elif messages is Array:
			for msg in messages:
				if msg is String:
					push_error(_format_message(msg))

func print_warning(messages: Variant) -> void:
	if _enabled:
		if messages is String:
			push_warning(_format_message(messages))
		elif messages is Array:
			for msg in messages:
				if msg is String:
					push_warning(_format_message(msg))

func print_rich(messages: Variant) -> void:
	if _enabled:
		if messages is String:
			print_rich(_format_message(messages))
		elif messages is Array:
			for msg in messages:
				if msg is String:
					print_rich(_format_message(msg))

func print_verbose(messages: Variant) -> void:
	if _enabled and OS.is_debug_build():
		if messages is String:
			print_verbose(_format_message(messages))
		elif messages is Array:
			for msg in messages:
				if msg is String:
					print_verbose(_format_message(msg))

# Helper method to print method entry/exit
func trace_method(method_name: String) -> void:
	if not _enabled:
		return
	print("→ %s.%s()" % [_prefix, method_name])

func trace_method_exit(method_name: String) -> void:
	if not _enabled:
		return
	print("← %s.%s()" % [_prefix, method_name])

func _init(owner: String = "", enabled: bool = false) -> void:
	_prefix = owner
	_enabled = enabled
	
func _format_message(message: String) -> String:
	return "[%s] %s" % [_prefix, message] if _prefix != "" else message

func _process_messages(messages: Variant) -> void:
	if not _enabled:
		return
		
	if messages is String:
		print(_format_message(messages))
	elif messages is Array:
		for message in messages:
			if message is String:
				print(_format_message(message))