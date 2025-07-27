extends Control

@export var _is_debug_enabled: bool = false

# Node references
@onready var input_field: LineEdit = $VBoxContainer/InputField
@onready var output_container: VBoxContainer = $VBoxContainer/ScrollContainer/OutputContainer
@onready var scroll_container: ScrollContainer = $VBoxContainer/ScrollContainer

func _ready() -> void:
	# Hide console by default
	hide()
	
	# Connect input field signals
	input_field.text_submitted.connect(_on_input_submitted)
	input_field.gui_input.connect(_on_input_gui_input)
	
	# Connect to console manager
	if not DeveloperConsole.command_executed.is_connected(_on_command_executed):
		DeveloperConsole.command_executed.connect(_on_command_executed)

func _input(event: InputEvent) -> void:
	# Toggle console with backtick key
	if event.is_action_pressed("toggle_console"):
		toggle_console()
		get_viewport().set_input_as_handled() # Consume the input event
	
	# Handle up/down arrows for command history
	if DeveloperConsole.is_visible and event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_UP:
				_navigate_history(-1)
			elif event.keycode == KEY_DOWN:
				_navigate_history(1)

func toggle_console() -> void:
	DeveloperConsole.set_console_visibility(!DeveloperConsole.is_visible)
	
	if DeveloperConsole.is_visible:
		show()
		input_field.grab_focus()
	else:
		hide()
		input_field.release_focus()

func _on_input_submitted(command: String) -> void:
	if command.strip_edges().is_empty():
		return
		
	# Add command to history
	DeveloperConsole.command_history.append(command)
	DeveloperConsole.history_index = DeveloperConsole.command_history.size()
	
	# Clear input
	input_field.text = ""
	
	# Print command to output
	print_to_console("> " + command)
	
	# Execute command
	DeveloperConsole.execute_command(command)

func _on_input_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			toggle_console()

func _on_command_executed(text: String) -> void:
	if text == "CLEAR":
		clear_console()
	else:
		print_to_console(text)

func print_to_console(text: String) -> void:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Set monospace font for consistent character spacing
	var label_settings = LabelSettings.new()
	label_settings.font_size = 24
	
	var mono_font = SystemFont.new()
	mono_font.font_names = ["Consolas", "Courier New", "Menlo", "Monospace"]  # pick a known system monospace
	label_settings.font = mono_font
	label.label_settings = label_settings
	
	output_container.add_child(label)
	
	# Scroll to bottom
	await get_tree().process_frame
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)

func clear_console() -> void:
	for child in output_container.get_children():
		child.queue_free()

func _navigate_history(direction: int) -> void:
	if DeveloperConsole.command_history.is_empty():
		return
		
	DeveloperConsole.history_index = clamp(DeveloperConsole.history_index + direction, 0, DeveloperConsole.command_history.size())
	
	if DeveloperConsole.history_index < DeveloperConsole.command_history.size():
		input_field.text = DeveloperConsole.command_history[DeveloperConsole.history_index]
		input_field.caret_column = input_field.text.length()
	else:
		input_field.text = ""
