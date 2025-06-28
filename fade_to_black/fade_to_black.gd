extends CanvasLayer
class_name FadeToBlack

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# Start fully transparent
	color_rect.color.a = 0
	color_rect.visible = false

	StageManager.transition_to_requested.connect(_on_fade_to_black_requested)

func _on_fade_to_black_requested(duration: float = 0.5) -> void:
	StageManager.transition_to_requested.disconnect(_on_fade_to_black_requested)
	color_rect.visible = true
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await tween.finished
	StageManager.transition_from_requested.connect(_on_fade_from_black_requested)
	StageManager.transition_to_completed.emit()

func _on_fade_from_black_requested(duration: float = 0.5) -> void:
	StageManager.transition_from_requested.disconnect(_on_fade_from_black_requested)
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await tween.finished
	color_rect.visible = false
	StageManager.transition_to_requested.connect(_on_fade_to_black_requested)
	StageManager.transition_from_completed.emit()