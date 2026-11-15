extends Node

signal updateLabel
@onready var take_button: Button = $TakeButton
@onready var minion_box: TextureRect = $TextureRect2
var minion : Equipments.Minion
var player : Player

func initialise(current_minion: Equipments.Minion, p: Player):
	minion = current_minion
	player = p
	match current_minion:
		Equipments.Minion.DAMAGE:
			minion_box.modulate = Color.INDIAN_RED
		Equipments.Minion.PROTECTION:
			minion_box.modulate = Color.DARK_CYAN
		Equipments.Minion.POTION:
			minion_box.modulate = Color.GREEN_YELLOW
		Equipments.Minion.STUN:
			minion_box.modulate = Color.SLATE_GRAY
		Equipments.Minion.FORESIGHT:
			minion_box.modulate = Color.DEEP_PINK

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		_on_take_button_pressed()

func _on_take_button_pressed():
	player.addMinion(minion)
	updateLabel.emit()
	queue_free()
	
