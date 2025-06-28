extends Node
class_name PhysicsProcessNode

signal physics_frame_ticked(delta: float)

func _physics_process(delta: float) -> void:
	physics_frame_ticked.emit(delta)