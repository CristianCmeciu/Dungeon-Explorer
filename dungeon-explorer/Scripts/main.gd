extends Node2D

@export var possible_rooms: Array[PackedScene]
var current_room: Node2D
var possible_minions: Array[Equipments.Minion]

var rooms_cleared = 0
var is_game_over = false

enum GameOverType {
	SUCCESS,
	TIMEOUT,
	DIED,
	TRAP
}

var gameover_timer: Timer 

@onready var game_timer = $GameTimer
@onready var HUD = $HUD
@onready var gameover_screen = $GameOverScreen
@onready var result_label = $GameOverScreen/CenterContainer/VBoxContainer/ResultLabel
@onready var play_again_btn = $GameOverScreen/CenterContainer/VBoxContainer/PlayAgainButton
@onready var quit_btn = $GameOverScreen/CenterContainer/VBoxContainer/QuitButton
@onready var player: Player = $HUD/Player
@onready var score_label: Label = $GameOverScreen/CenterContainer/VBoxContainer/ScoreLabel
@onready var hp_left: ColorRect = $"HUD/PlayerUI/HP+Time/HPBar/HPMax/HPLeft"
@onready var time_left: ColorRect = $"HUD/PlayerUI/HP+Time/TimeBar/TimeMax/TimeLeft"
@onready var blindness_left: ColorRect = $"HUD/PlayerUI/Potions+Stats/Potions/Blindness/BlindnessMax/BlindnessLeft"
@onready var poison_left: ColorRect = $"HUD/PlayerUI/Potions+Stats/Potions/Poison/PoisonMax/PoisonLeft"
@onready var weakness_left: ColorRect = $"HUD/PlayerUI/Potions+Stats/Potions/Weakness/WeaknessMax/WeaknessLeft"
@onready var gold_label: Label = $"HUD/PlayerUI/Potions+Stats/Stats/Gold/GoldLabel"
@onready var weapon_label: Label = $"HUD/PlayerUI/Potions+Stats/Stats/Weapon/WeaponLabel"
@onready var armor_label: Label = $"HUD/PlayerUI/Potions+Stats/Stats/Armor/ArmorLabel"
@onready var minion_foresight: TextureRect = $HUD/MinionForesight
@onready var minion_stun: TextureRect = $HUD/MinionStun
@onready var minion_attack: TextureRect = $HUD/MinionAttack
@onready var minion_defend: TextureRect = $HUD/MinionDefend
@onready var minion_potion: TextureRect = $HUD/MinionPotion




func _ready():
	game_timer.timeout.connect(_on_timer_timeout)
	play_again_btn.pressed.connect(_on_play_again_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	player.died.connect(game_over.bind(GameOverType.DIED))
	gameover_timer = Timer.new()
	gameover_timer.wait_time = 2.0
	gameover_timer.one_shot = true
	add_child(gameover_timer)
	start_game()
	
func start_game():
	possible_minions.append(Equipments.Minion.DAMAGE)
	possible_minions.append(Equipments.Minion.PROTECTION)
	possible_minions.append(Equipments.Minion.POTION)
	possible_minions.append(Equipments.Minion.STUN)
	possible_minions.append(Equipments.Minion.FORESIGHT)
	possible_minions.shuffle()
	minion_attack.hide()
	minion_defend.hide()
	minion_foresight.hide()
	minion_potion.hide()
	minion_stun.hide()
	hp_left.size.x = hp_left.custom_maximum_size.x
	time_left.size.x = time_left.custom_maximum_size.x
	blindness_left.size.x = 0
	weakness_left.size.x = 0
	poison_left.size.x = 0
	
	HUD.show()
	AudioManager.play_sound("bg_sound")
	is_game_over = false
	rooms_cleared = 0
	gameover_screen.hide()
	game_timer.start(20000.0)
	player.initialize()
	generate_next_room("nimic")

func generate_next_room(next_event: String):
	if is_game_over:
		return
	if current_room:
		current_room.queue_free()
		rooms_cleared += 1
	if rooms_cleared >= 12000:
		game_over(GameOverType.SUCCESS)
		return
		
	var next_scene = possible_rooms.pick_random()
	current_room = next_scene.instantiate()
	
	if next_event=="minion room":
		current_room.initialise(player,rooms_cleared, true if possible_minions.size()-1 == 0 else false)
	else:
		current_room.initialise(player,rooms_cleared,possible_minions.is_empty())
		
	current_room.updateLabel.connect(updateLabel)
	current_room.room_completed.connect(generate_next_room)
	current_room.room_died.connect(game_over.bind(GameOverType.TRAP)) 
	add_child(current_room)
	
	if next_event=="minion room":
		current_room.setup(next_event,possible_minions[0])
		possible_minions.pop_front()
	else: 
		current_room.setup(next_event)

	
func updateLabel():
	
	hp_left.size.x = (hp_left.custom_maximum_size.x / 100) * player.hp
	gold_label.text = str(player.gold) + " gold"
		
	if player.armor:
		if Equipments.Minion.PROTECTION in player.owned_minions:
			armor_label.text = "+" + str(player.armor.defense + 1) + " DEF"
		else:
			armor_label.text = "+" + str(player.armor.defense) + " DEF"
	else:
		armor_label.text = "+0 DEF"
		
	if player.weapon:
		if Equipments.Minion.DAMAGE in player.owned_minions:
			weapon_label.text = "+" + str(player.weapon.damage + 2) + " DMG"
		else:
			weapon_label.text = "+" + str(player.weapon.damage) + " DMG"
		if player.weapon.stunTime:
			weapon_label.text += "\n"
			if Equipments.Minion.STUN in player.owned_minions:
				weapon_label.text +="2r Stun"
			else:
				weapon_label.text += "1r Stun"
		elif Equipments.Minion.STUN in player.owned_minions:
			weapon_label.text += "\n 1r Stun"
		if player.weapon.effect:
			weapon_label.text += "\n Bleed"
	else:
		weapon_label.text = "+1 dmg"
		
	if Equipments.Minion.POTION in player.owned_minions:
		minion_potion.show()
	if Equipments.Minion.FORESIGHT in player.owned_minions:
		minion_foresight.show()
	if Equipments.Minion.DAMAGE in player.owned_minions:
		minion_attack.show()
	if Equipments.Minion.PROTECTION in player.owned_minions:
		minion_defend.show()
	if Equipments.Minion.STUN in player.owned_minions:
		minion_stun.show()
		
	if player.statusEffectManager.hasEffect("Poison"):
		poison_left.size.x = (poison_left.custom_maximum_size.x / 3) * player.statusEffectManager.getRoundsLeft("Poison")
	if player.statusEffectManager.hasEffect("Weakness"):
		weakness_left.size.x = (weakness_left.custom_maximum_size.x / 3) * player.statusEffectManager.getRoundsLeft("Weakness")
	if player.statusEffectManager.hasEffect("Blindness"):
		blindness_left.size.x = (blindness_left.custom_maximum_size.x / 3) * player.statusEffectManager.getRoundsLeft("Blindness")
	
func _process(_delta):
	
	if not is_game_over:
		time_left.size.x = (time_left.custom_maximum_size.x / 20) * game_timer.time_left
	else:
		if gameover_timer.is_stopped():
			if Input.is_action_just_pressed("attack"):
				start_game()
			if Input.is_action_just_pressed("defend"):
				get_tree().quit()
		

func _on_timer_timeout():
	if not is_game_over:
		game_over(GameOverType.TIMEOUT)
		
func game_over(cond: GameOverType):
	
	if is_game_over:
		return
	
	is_game_over = true
	gameover_timer.start()
	game_timer.stop()
	HUD.hide()
	
	if current_room:
		current_room.queue_free()
		
	gameover_screen.show()	
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
		GameOverType.DIED:
			result_label.text = "ai murit"
			result_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))
			
	score_label.text = "Score: "+ str(player.gold)


func _on_play_again_pressed():
	start_game()

func _on_quit_pressed():
	get_tree().quit()
