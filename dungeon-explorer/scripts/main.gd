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
	game_timer.start(20.0)
	
	generate_next_room("nimic")

func generate_next_room(next_event: String):
	if is_game_over:
		return
	if current_room:
		current_room.queue_free()
		rooms_cleared += 1
	if rooms_cleared >= 15:
		game_over(GameOverType.SUCCESS)
		return
	
	var next_scene = possible_rooms.get(0)
	
	if next_event == "usa fache":
		next_scene = possible_rooms.get(1)
	else: if next_event == "treasure room":
		next_scene = possible_rooms.get(2)
	else: if next_event == "mimic fight":
		next_scene = possible_rooms.get(3)
	else:
		next_scene = possible_rooms.get(0)
	current_room = next_scene.instantiate()
	
	current_room.room_completed.connect(generate_next_room)
	current_room.room_died.connect(game_over.bind(GameOverType.TRAP)) 
	add_child(current_room)
	
	current_room.setup(next_event)
	
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
