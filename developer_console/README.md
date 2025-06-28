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
func _register_game_commands() -> void:
    register_command("my_command", _cmd_my_command, "Description")

func _cmd_my_command(args: Array = []) -> void:
    command_executed.emit("My command executed")
```

### Built-in commands
- `help` - Show available commands
- `clear` - Clear console output  
- `echo [text]` - Print text

### Setup
1. Add autoload: `DeveloperConsole="*res://singleton/developer_console.gd"`
2. Add input action: `toggle_console` → backtick key
3. Add console UI scene to your stage 