class_name FloatingText
extends Node2D

@onready var label: Label = $Label

func setup(text_to_show: String, text_color: Color, start_pos: Vector2, duration: float = 1.1) -> Signal:
	global_position = start_pos
	label.text = text_to_show
	label.add_theme_color_override("font_color", text_color)
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 60.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_ease(Tween.EASE_IN)
	
	tween.finished.connect(queue_free)
	return tween.finished
