extends Area2D

signal clicked(next_event: String)
signal fake_clicked

@onready var highlight = $Polygon2D
var target_event: String = ""
var is_fake: bool = false 
var is_disabled: bool = false
var hasMinion: bool = false
var wasClicked: bool = false
var mist_particles: CPUParticles2D

func _ready():
	highlight.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)
	
func applyMinion(hasForesight: bool):
	hasMinion = hasForesight
	_setup_procedural_mist()
	if target_event == "treasure room" or target_event == "minion room":
		set_door_mist("good")
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)
	elif target_event in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
		set_door_mist("bad")
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)
	else:
		set_door_mist("none")
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)

func set_target_event(event_name: String,has_minion: bool):
	hasMinion = has_minion
	target_event = event_name
	wasClicked = false
	if has_minion:
		if event_name == "treasure room" or target_event == "minion room":
			set_door_mist("good")
			highlight.color = Color(1.0, 1.0, 1.0, 0.4)
		elif event_name in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
			set_door_mist("bad")
			highlight.color = Color(1.0, 1.0, 1.0, 0.4)
		else:
			set_door_mist("none")
			highlight.color = Color(1.0, 1.0, 1.0, 0.4)
	else:
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)


func set_door_mist(state: String) -> void:
	if not mist_particles:
		return
		
	match state:
		"good": 
			mist_particles.emitting = true
			mist_particles.modulate = Color(0.3, 1.0, 0.5, 0.85)
		"bad":
			mist_particles.emitting = true
			mist_particles.modulate = Color(0.85, 0.15, 0.25, 0.85)
		"none":
			mist_particles.emitting = true

func _setup_procedural_mist() -> void:
	mist_particles = CPUParticles2D.new()
	mist_particles.amount = 35
	mist_particles.lifetime = 2.2
	mist_particles.preprocess = 1.0
	mist_particles.z_index = 5
	
	mist_particles.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	var grad_tex := GradientTexture2D.new()
	grad_tex.width = 64
	grad_tex.height = 64
	grad_tex.fill = GradientTexture2D.FILL_RADIAL
	grad_tex.fill_from = Vector2(0.5, 0.5)
	grad_tex.fill_to = Vector2(0.5, 0.0) # Radius reaches the edge
	
	var tex_grad := Gradient.new()
	tex_grad.set_color(0, Color(1, 1, 1, 0.45)) 
	tex_grad.set_color(1, Color(1, 1, 1, 0.0)) 
	grad_tex.gradient = tex_grad
	mist_particles.texture = grad_tex
	
	mist_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	mist_particles.emission_rect_extents = Vector2(25.0, 5.0) 
	
	mist_particles.direction = Vector2(0, -1)
	mist_particles.spread = 35.0
	mist_particles.initial_velocity_min = 12.0
	mist_particles.initial_velocity_max = 28.0
	mist_particles.gravity = Vector2(0, -5)
	
	mist_particles.scale_amount_min = 0.8
	mist_particles.scale_amount_max = 1.6
	
	var alpha_curve := Gradient.new()
	alpha_curve.add_point(0.0, Color(1, 1, 1, 0.0))
	alpha_curve.add_point(0.25, Color(1, 1, 1, 1.0))
	alpha_curve.add_point(1.0, Color(1, 1, 1, 0.0))
	
	mist_particles.color_ramp = alpha_curve
	
	mist_particles.position = Vector2(9, 348)
	add_child(mist_particles)

func _on_mouse_entered():
	if not is_disabled:
		highlight.show()

func _on_mouse_exited():
	highlight.hide()
	if !hasMinion:
		highlight.hide()
		
func pressed():
	if is_fake and mist_particles:
		mist_particles.hide()
	is_disabled = true
	wasClicked = true
	highlight.hide()
	fake_clicked.emit()

func _on_input_event(_viewport, event, _shape_idx):
	if is_disabled:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_fake and !wasClicked:
			if mist_particles:
				mist_particles.hide()
			wasClicked = true
			is_disabled = true
			highlight.hide()
			fake_clicked.emit()
		else:
			clicked.emit(target_event)
