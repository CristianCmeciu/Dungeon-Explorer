extends Node

signal updateLabel
@onready var take_button: Button = $CanvasLayer/MinionOverlay/Buttons/SaveBtn
@onready var minion_box: TextureRect = $CanvasLayer/MinionOverlay/MinionTexture
@onready var text: Label = $CanvasLayer/MinionOverlay/Label
var minion : Equipments.Minion
var player : Player
var minion_avatars = ["res://Assets/minion_1_1.0.png",
					"res://Assets/minion_2_1.0.png",
					"res://Assets/minion_3_1.0.png",
					"res://Assets/minion_4_1.0.png"]
signal foresight

func initialise(current_minion: Equipments.Minion, p: Player):
	minion = current_minion
	player = p
	text.text = "You found a helpless minion!"
	match current_minion:
		Equipments.Minion.DAMAGE:
			text.text += "\nIt makes you feel more powerful."
			minion_box.modulate = Color.INDIAN_RED
			minion_box.texture = load(minion_avatars[randi()%4])
		Equipments.Minion.PROTECTION:
			text.text += "\nIt makes you feel protected."
			minion_box.modulate = Color.DARK_CYAN
			minion_box.texture = load(minion_avatars[randi()%4])
		Equipments.Minion.POTION:
			text.text += "\nYou feel a magic aura from it!"
			minion_box.modulate = Color.GREEN_YELLOW
			minion_box.texture = load(minion_avatars[randi()%4])
		Equipments.Minion.STUN:
			text.text += "\nYour attacks feel stunning!"
			minion_box.modulate = Color.SLATE_GRAY
			minion_box.texture = load(minion_avatars[randi()%4])
		Equipments.Minion.FORESIGHT:
			text.text += "\nYou can feel what comes up next."
			minion_box.modulate = Color.DEEP_PINK
			minion_box.texture = load(minion_avatars[randi()%4])


func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		_on_take_button_pressed()

func _on_take_button_pressed():
	AudioManager.stop_sound(AudioManager.SoundType.MINION_CRY)
	AudioManager.play_sound(AudioManager.SoundType.MINION_HAPPY)
	if minion == Equipments.Minion.FORESIGHT:
		foresight.emit()
	player.addMinion(minion)
	updateLabel.emit()
	queue_free()
	
