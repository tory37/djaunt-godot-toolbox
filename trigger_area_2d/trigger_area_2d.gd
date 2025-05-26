extends Area2D

class_name TriggerArea2D

signal on_trigger_entered(collider: Node2D)
signal on_trigger_exited(collider: Node2D)

@export var should_log: bool = false

func _ready() -> void:
	# Connect the built-in Area2D signals to our custom trigger signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_body_entered(body: Node2D) -> void:
	if should_log:
		print("Trigger entered by body: ", body.name)
	on_trigger_entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if should_log:
		print("Trigger exited by body: ", body.name)
	on_trigger_exited.emit(body)

func _on_area_entered(area: Area2D) -> void:
	if should_log:
		print("Trigger entered by area: ", area.name)
	on_trigger_entered.emit(area)

func _on_area_exited(area: Area2D) -> void:
	if should_log:
		print("Trigger exited by area: ", area.name)
	on_trigger_exited.emit(area)