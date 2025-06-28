# StageManager is responsible for managing the current stage and handling stage changes.
# Setup:
# - Add as an autoload singleton to the project
# - Have a node in the scene tree called "ActiveStages" that will contain the current stage
extends Node

var current_stage: Node

# Stage Change Signals
# Emitted when we want to change to a new stage
signal stage_change_requested(stage_name: String)
# Emitted when the stage change is started
signal stage_change_started()
# Emitted when the stage change is finished and level ready has been emitted
signal stage_change_finished()

# Transition Signals
## Emitted when we want to start transitioning to a new state (e.g., fade to black, show loading screen)
signal transition_to_requested()
## Emitted when the transition to the new state is complete (e.g., screen is fully black, loading screen is visible)
signal transition_to_completed()
## Emitted when we want to start transitioning back to the normal state (e.g., fade from black, hide loading screen)
signal transition_from_requested()
## Emitted when the transition back to normal state is complete (e.g., screen is fully visible again)
signal transition_from_completed()

# The stage should emit this signal when it is ready to be used
signal stage_initialized()

var _debug: Debug = Debug.new("StageManager", true)

func _ready() -> void:
	_debug.trace_method("ready")
	stage_change_requested.connect(_on_stage_change_requested)

func _on_stage_change_requested(stage_path: String) -> void:
	stage_change_requested.disconnect(_on_stage_change_requested)
	_debug.trace_method("on_stage_change_requested")
	
	if not stage_path:
		push_error("Stage name is empty")
		return

	# Check if the stage exists
	if not FileAccess.file_exists(stage_path):
		push_error("Stage does not exist at path: ", stage_path)
		return

	stage_change_started.emit()

	# Start transtion
	transition_to_completed.connect(_on_transition_to_complete.bind(stage_path))
	transition_to_requested.emit()

	
func _on_transition_to_complete(stage_path: String) -> void:
	_debug.trace_method("on_transition_to_complete")
	transition_to_completed.disconnect(_on_transition_to_complete)
	
	# Remove the current scene if it exists
	if current_stage:
		current_stage.queue_free()

	stage_initialized.connect(_on_stage_initialized)

	# Load and instance the new scene
	var stage_resource = load(stage_path)
	if !stage_resource:
		push_error("Failed to load stage at path: ", stage_path)
		return
		
	current_stage = stage_resource.instantiate()
	
	# Find ActiveStages container
	var active_stages = get_tree().root.find_child("ActiveStages", true, false)
	if !active_stages:
		push_error("ActiveStages container not found in scene tree")
		return
		
	# Add as first child to ensure it's behind other elements
	active_stages.add_child(current_stage)

func _on_stage_initialized() -> void:
	_debug.trace_method("on_stage_initialized")
	stage_initialized.disconnect(_on_stage_initialized)

	# Fade from black
	transition_from_completed.connect(_on_transition_from_complete)
	transition_from_requested.emit()

func _on_transition_from_complete() -> void:
	_debug.trace_method("on_transition_from_complete")
	transition_from_completed.disconnect(_on_transition_from_complete)
	stage_change_requested.connect(_on_stage_change_requested)
	stage_change_finished.emit()