## ProcessNode - Frame Processing Node
##
## PURPOSE: Emits frame_ticked signal during _process().
## Used by ProcessManager for lazy initialization.
##
## USAGE: Connect to frame_ticked signal for frame updates.

extends Node
class_name ProcessNode

signal frame_ticked(delta: float)

func _process(delta: float) -> void:
	frame_ticked.emit(delta)