extends Node
class_name DjauntDeveloperConsole

const _is_debug_enabled: bool = true

# Signals
signal command_executed(command_response: String)
signal console_opened
signal console_closed

# Console state
var is_visible: bool = false
var command_history: Array[String] = []
var history_index: int = -1

# Command registry
var commands: Dictionary = {}

func _ready() -> void:
	# Register basic commands
	register_command("help", _cmd_help, "Show available commands")
	register_command("clear", _cmd_clear, "Clear the console output")
	register_command("echo", _cmd_echo, "[text] - Print text to the console")
	
	# Call virtual method for derived classes to register their commands
	_register_game_commands()

func register_command(command_name: String, callback: Callable, description: String) -> void:
	commands[command_name] = {
		"callback": callback,
		"description": description
	}

func execute_command(command: String) -> void:
	var parts = command.split(" ", false)
	var cmd_name = parts[0].to_lower()
	
	if commands.has(cmd_name):
		var args: PackedStringArray = parts.slice(1) if parts.size() > 1 else PackedStringArray()
		commands[cmd_name].callback.call(args)
	else:
		command_executed.emit("Unknown command: " + cmd_name)

func set_console_visibility(visible: bool) -> void:
	is_visible = visible
	if visible:
		console_opened.emit()
	else:
		console_closed.emit()

# Virtual method for derived classes to override and register game-specific commands
func _register_game_commands() -> void:
	pass

# Command implementations
func _cmd_help(_args: Array = []) -> void:
	var help_text = "Available commands:\n"
	for cmd_name in commands:
		help_text += "- " + cmd_name + ": " + commands[cmd_name].description + "\n"
	command_executed.emit(help_text)

func _cmd_clear(_args: Array = []) -> void:
	command_executed.emit("CLEAR")

func _cmd_echo(args: Array = []) -> void:
	if args.is_empty():
		command_executed.emit("Usage: echo <text>")
		return
	command_executed.emit(" ".join(args))