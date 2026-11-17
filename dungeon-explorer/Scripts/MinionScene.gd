extends Node

signal updateLabel
@onready var take_button: Button = $CanvasLayer/MinionOverlay/Buttons/SaveBtn
@onready var minion_box: TextureRect = $CanvasLayer/MinionOverlay/MinionTexture
@onready var text: Label = $CanvasLayer/MinionOverlay/Label
var minion : Equipments.Minion
var player : Player
signal foresight

func initialise(current_minion: Equipments.Minion, p: Player):
	minion = current_minion
	player = p
	text.text = "You found a helpless minion!"
	match current_minion:
		Equipments.Minion.DAMAGE:
			text.text += "\nIt makes you feel more powerful."
			minion_box.modulate = Color.INDIAN_RED
		Equipments.Minion.PROTECTION:
			text.text += "\nIt makes you feel protected."
			minion_box.modulate = Color.DARK_CYAN
		Equipments.Minion.POTION:
			text.text += "\nYou feel a magic aura from it!"
			minion_box.modulate = Color.GREEN_YELLOW
		Equipments.Minion.STUN:
			text.text += "\nYour attacks feel stunning!"
			minion_box.modulate = Color.SLATE_GRAY
		Equipments.Minion.FORESIGHT:
			text.text += "\nYou can feel what comes up next."
			minion_box.modulate = Color.DEEP_PINK

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		_on_take_button_pressed()

func _on_take_button_pressed():
	if minion == Equipments.Minion.FORESIGHT:
		foresight.emit()
	player.addMinion(minion)
	updateLabel.emit()
	queue_free()
	
