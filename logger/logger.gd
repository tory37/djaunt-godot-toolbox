extends Node

signal log(message: String, prefix: String)

func _ready() -> void:
	log.connect(_on_log_message)

func _on_log_message(message: String = "Empty Log", prefix: String = "") -> void:
	print(prefix + message)