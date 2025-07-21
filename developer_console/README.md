# Developer Console Template

A minimal developer console template for Godot games.

## Usage

### Access the console
```gdscript
DeveloperConsole.execute_command("help")
```

### Add commands
In `singleton/developer_console.gd`:

```gdscript
extends DjauntDeveloperConsole

# Step 1: Override this method to register your game's commands
func _register_game_commands() -> void:
	# Register each command with: name, callback function, description
	register_command("my_command", _cmd_my_command, "Description of what this command does")
	register_command("another_command", _cmd_another_command, "Another command description")

# Step 2: Implement your command functions
# All command functions receive an Array of string arguments
func _cmd_my_command(args: Array = []) -> void:
	# Step 2a: Validate arguments if needed
	if args.size() < 1:
		command_executed.emit("Usage: my_command <required_argument>")
		return
	
	# Step 2b: Parse arguments
	var required_arg: String = args[0]
	var optional_arg: String = args[1] if args.size() > 1 else "default"
	
	# Step 2c: Execute your game logic here
	# ... your actual command implementation ...
	
	# Step 2d: Build output string and emit signal
	var output: String = "Command executed with: " + required_arg
	if args.size() > 1:
		output += " and " + optional_arg
	command_executed.emit(output)

func _cmd_another_command(args: Array = []) -> void:
	# Example with no arguments
	var output: String = "Another command executed successfully!"
	command_executed.emit(output)
```

### Important Notes
- `command_executed.emit()` expects a **single string parameter**
- Build your output string before emitting the signal
- Use `\n` for line breaks in console output
- Command arguments come as an Array of strings

### Built-in commands
- `help` - Show available commands
- `clear` - Clear console output  
- `echo [text]` - Print text

### Setup
1. Add autoload: `DeveloperConsole="*res://singleton/developer_console.gd"`
2. Add input action: `toggle_console` → backtick key
3. Add console UI scene to your stage 
