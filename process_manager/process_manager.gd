## ProcessManager - Lazy Process Management
##
## PURPOSE: Only creates process nodes when subscribers exist.
## Zero overhead when unused, single process call when active.
##
## USAGE:
## ProcessManager.subscribe_to_frame_ticked(_on_frame_ticked)
## ProcessManager.unsubscribe_from_frame_ticked(_on_frame_ticked)
## ProcessManager.subscribe_to_physics_ticked(_on_physics_ticked)
## ProcessManager.unsubscribe_from_physics_ticked(_on_physics_ticked)

extends Node

const process_node_scene: PackedScene = preload("uid://bg0c3y6cvnfun")
const physics_process_node_scene: PackedScene = preload("uid://besux80xpicqk")

var _node_instance: ProcessNode = null
var _physics_node_instance: PhysicsProcessNode = null

# callback signature: func callback_name(delta: float) -> void
func subscribe_to_frame_ticked(callback: Callable) -> void:
	if not callback.is_valid():
		push_error("ProcessManager: Invalid callback provided to subscribe_to_frame_ticked")
		return
		
	if not _node_instance:
		_node_instance = process_node_scene.instantiate()
		if not _node_instance:
			push_error("ProcessManager: Failed to instantiate process node scene")
			return
		add_child(_node_instance)

	_node_instance.frame_ticked.connect(callback)

# callback signature: func callback_name(delta: float) -> void
func unsubscribe_from_frame_ticked(callback: Callable) -> void:
	if not _node_instance:
		return
		
	if _node_instance.frame_ticked.is_connected(callback):
		_node_instance.frame_ticked.disconnect(callback)

	if _node_instance.frame_ticked.get_connections().size() == 0:
		_node_instance.queue_free()
		_node_instance = null

func is_subscribed_to_frame_ticked(callback: Callable) -> bool:
	if not _node_instance:
		return false

	return _node_instance.frame_ticked.is_connected(callback)

# callback signature: func callback_name(delta: float) -> void
func subscribe_to_physics_ticked(callback: Callable) -> void:
	if not callback.is_valid():
		push_error("ProcessManager: Invalid callback provided to subscribe_to_physics_ticked")
		return
		
	if not _physics_node_instance:
		_physics_node_instance = physics_process_node_scene.instantiate()
		if not _physics_node_instance:
			push_error("ProcessManager: Failed to instantiate physics process node scene")
			return
		add_child(_physics_node_instance)

	_physics_node_instance.physics_frame_ticked.connect(callback)

# callback signature: func callback_name(delta: float) -> void
func unsubscribe_from_physics_ticked(callback: Callable) -> void:
	if not _physics_node_instance:
		return
		
	if _physics_node_instance.physics_frame_ticked.is_connected(callback):
		_physics_node_instance.physics_frame_ticked.disconnect(callback)

	if _physics_node_instance.physics_frame_ticked.get_connections().size() == 0:
		_physics_node_instance.queue_free()
		_physics_node_instance = null

func is_subscribed_to_physics_ticked(callback: Callable) -> bool:
	if not _physics_node_instance:
		return false

	return _physics_node_instance.physics_frame_ticked.is_connected(callback)
