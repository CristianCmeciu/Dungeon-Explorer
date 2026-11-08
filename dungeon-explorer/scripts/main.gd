extends Node2D

@export var possible_rooms: Array[PackedScene]
var current_room: Node2D

var rooms_cleared = 0
var is_game_over = false

enum GameOverType {
	SUCCESS,
	TIMEOUT,
	TRAP
}

@onready var game_timer = $GameTimer
@onready var time_label = $HUD/TimeLabel
@onready var gameover_screen = $GameOverScreen
@onready var result_label = $GameOverScreen/CenterContainer/VBoxContainer/ResultLabel
@onready var play_again_btn = $GameOverScreen/CenterContainer/VBoxContainer/PlayAgainButton
@onready var quit_btn = $GameOverScreen/CenterContainer/VBoxContainer/QuitButton
@onready var hp_label: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/Hp
@onready var gold_label: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/Gold
@onready var armor_label: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer2/Armor
@onready var weapon_label: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer2/Weapon
@onready var player: Player = $HUD/Player

func _ready():
	game_timer.timeout.connect(_on_timer_timeout)
	play_again_btn.pressed.connect(_on_play_again_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	
	start_game()
	
func start_game():
	is_game_over = false
	rooms_cleared = 0
	gameover_screen.hide()
	time_label.show()
	game_timer.start(20000.0)
	player.initialize()
	generate_next_room("nimic")

func generate_next_room(next_event: String):
	if is_game_over:
		return
	if current_room:
		current_room.queue_free()
		rooms_cleared += 1
	if rooms_cleared >= 15000:
		game_over(GameOverType.SUCCESS)
		return
		
	var next_scene = possible_rooms.pick_random()
	current_room = next_scene.instantiate()
	current_room.initialise(player)
	current_room.updateLabel.connect(updateLabel)
	current_room.room_completed.connect(generate_next_room)
	current_room.room_died.connect(game_over.bind(GameOverType.TRAP)) 
	add_child(current_room)
	
	current_room.setup(next_event)
	
func updateLabel():
	hp_label.text = "HP: %d / %d" % [player.hp, player.maxHp]
	gold_label.text = "Gold: %d" % player.gold
		
	if player.armor:
		armor_label.text = "Armor: %s (DEF: %d)" % [player.armor.name, player.armor.defense]
	else:
		armor_label.text = "Armor: None"
		
	if player.weapon:
		weapon_label.text = "Weapon: %s (ATK: %d)" % [player.weapon.name, player.weapon.damage]
	else:
		weapon_label.text = "Weapon: None"
	
func _process(_delta):
	
	if not is_game_over:
		time_label.text = "Time left: %.1f" % game_timer.time_left
		
func _on_timer_timeout():
	
	if not is_game_over:
		game_over(GameOverType.TIMEOUT)
		
func game_over(cond: GameOverType):
	
	is_game_over = true
	game_timer.stop()
	
	if current_room:
		current_room.queue_free()
		
	gameover_screen.show()
	time_label.hide()
	
	match cond:
		GameOverType.SUCCESS:
			result_label.text = "BRAVO!!"
			result_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
		GameOverType.TIMEOUT:
			result_label.text = "vaide capu tau"
			result_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))
		GameOverType.TRAP:
			result_label.text = "ai cazut in capcana"
			result_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))


func _on_play_again_pressed():
	start_game()

func _on_quit_pressed():
	get_tree().quit()
