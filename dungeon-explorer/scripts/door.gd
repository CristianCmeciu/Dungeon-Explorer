extends Area2D

signal clicked(next_event: String)
signal fake_clicked

@onready var highlight = $Polygon2D
var target_event: String = ""
var is_fake: bool = false 
var is_disabled: bool = false


func _ready():
	highlight.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func set_target_event(event_name: String):
	target_event = event_name
	
	if event_name == "treasure room":
		highlight.color = Color(1.0, 0.8, 0.0, 0.4)
	elif event_name in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
		highlight.color = Color(1.0, 0.0, 0.0, 0.4)
	else:
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)

func _on_mouse_entered():
	if not is_disabled:
		highlight.show()

func _on_mouse_exited():
	highlight.hide()

func _on_input_event(_viewport, event, _shape_idx):
	if is_disabled:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_fake:
			is_disabled = true
			highlight.hide()
			fake_clicked.emit()
		else:
			clicked.emit(target_event)
