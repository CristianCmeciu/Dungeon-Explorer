extends Area2D

signal clicked(next_event: String)
signal fake_clicked

@onready var highlight = $Polygon2D
var target_event: String = ""
var is_fake: bool = false 
var is_disabled: bool = false
var hasMinion: bool = false
var wasClicked: bool = false

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
		#highlight.color = Color(1.0, 0.8, 0.0, 0.4)
	elif target_event in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
		#highlight.color = Color(1.0, 0.0, 0.0, 0.4)
		set_door_mist("bad")
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)
	else:
		set_door_mist("none")
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)
		#highlight.color = Color(1.0, 1.0, 1.0, 0.4)

func set_mist_fake():
	if hasMinion:
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
			#highlight.color = Color(1.0, 0.8, 0.0, 0.4)
		elif event_name in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
			#highlight.color = Color(1.0, 0.0, 0.0, 0.4)
			set_door_mist("bad")
			highlight.color = Color(1.0, 1.0, 1.0, 0.4)
		else:
			set_door_mist("none")
			highlight.color = Color(1.0, 1.0, 1.0, 0.4)
			#highlight.color = Color(1.0, 1.0, 1.0, 0.4)
	else:
		#if event_name == "treasure room":
			#highlight.color = Color(0, 1, 0, 0.4)
		#elif event_name in ["witch fight", "trap room", "mimic fight", "skeleton fight"]:
			#highlight.color = Color(1.0, 0.0, 1, 0.4)
		#else:
			#highlight.color = Color(1.0, 1.0, 1.0, 0.4)
		highlight.color = Color(1.0, 1.0, 1.0, 0.4)


var mist_particles: GPUParticles2D


# Call this from room.gd when setting up doors!
func set_door_mist(state: String) -> void:
	if not mist_particles:
		return
		
	match state:
		"good": # e.g., treasure room
			mist_particles.emitting = true
			mist_particles.modulate = Color(0.3, 1.0, 0.5, 0.85) # Emerald/gold mist
		"bad": # e.g., trap room / fight / fake door
			mist_particles.emitting = true
			mist_particles.modulate = Color(0.85, 0.15, 0.25, 0.85) # Crimson/dark red mist
		"none":
			mist_particles.emitting = true
		"test":
			mist_particles.emitting = true
			mist_particles.modulate = Color.ORANGE

func _setup_procedural_mist() -> void:
	mist_particles = GPUParticles2D.new()
	mist_particles.amount = 35
	mist_particles.lifetime = 2.2
	mist_particles.preprocess = 1.0 # Starts already active so there's no initial delay
	mist_particles.z_index = 5 # Renders in front of the door sprite
	
	mist_particles.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# 1. Create a soft circular texture via code (no external asset needed)
	var grad_tex := GradientTexture2D.new()
	grad_tex.width = 64
	grad_tex.height = 64
	grad_tex.fill = GradientTexture2D.FILL_RADIAL
	grad_tex.fill_from = Vector2(0.5, 0.5)
	grad_tex.fill_to = Vector2(0.5, 0.0) # Radius reaches the edge
	
	var tex_grad := Gradient.new()
	tex_grad.set_color(0, Color(1, 1, 1, 0.45)) # Soft center
	tex_grad.set_color(1, Color(1, 1, 1, 0.0))  # Transparent edge
	grad_tex.gradient = tex_grad
	mist_particles.texture = grad_tex
	
	# 2. Configure particle behavior
	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(25.0, 5.0, 0.0) # Width of the door base/frame
	
	# Gentle upward and outward drift
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 35.0
	mat.initial_velocity_min = 12.0
	mat.initial_velocity_max = 28.0
	mat.gravity = Vector3(0, -5, 0)
	
	# Scale expansion as mist dissipates
	mat.scale_min = 0.8
	mat.scale_max = 1.6
	
	# Fade in and out smoothly over lifetime
	var alpha_curve := Gradient.new()
	alpha_curve.add_point(0.0, Color(1, 1, 1, 0.0))
	alpha_curve.add_point(0.25, Color(1, 1, 1, 1.0))
	alpha_curve.add_point(1.0, Color(1, 1, 1, 0.0))
	
	var alpha_tex := GradientTexture1D.new()
	alpha_tex.gradient = alpha_curve
	mat.color_ramp = alpha_tex
	
	mist_particles.process_material = mat
	# Position at the bottom threshold of the door (adjust Y offset to match your door sprite)
	mist_particles.position = Vector2(90, 310)
	add_child(mist_particles)

func _on_mouse_entered():
	if not is_disabled:
		highlight.show()

func _on_mouse_exited():
	highlight.hide()
	if !hasMinion:
		highlight.hide()
		
func pressed():
	is_disabled = true
	wasClicked = true
	highlight.hide()
	fake_clicked.emit()

func _on_input_event(_viewport, event, _shape_idx):
	if is_disabled:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_fake and !wasClicked:
			wasClicked = true
			is_disabled = true
			highlight.hide()
			fake_clicked.emit()
		else:
			clicked.emit(target_event)
