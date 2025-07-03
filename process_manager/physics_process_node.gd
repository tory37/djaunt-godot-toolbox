## PhysicsProcessNode - Physics Frame Processing Node
##
## PURPOSE: Emits physics_frame_ticked signal during _physics_process().
## Used by ProcessManager for lazy initialization.
##
## USAGE: Connect to physics_frame_ticked signal for physics updates.

extends Node
class_name PhysicsProcessNode

signal physics_frame_ticked(delta: float)

func _physics_process(delta: float) -> void:
	physics_frame_ticked.emit(delta)