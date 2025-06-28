extends Node

signal frame_ticked(delta: float)

func _process(delta: float) -> void:
	frame_ticked.emit(delta)
