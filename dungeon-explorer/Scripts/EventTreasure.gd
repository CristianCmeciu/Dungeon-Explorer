extends Node2D

signal treasure_chosen
signal updateLabel

@onready var chest_label: Label = $CanvasLayer/TreasureOverlay/Label
@onready var pass_btn: Button = $CanvasLayer/TreasureOverlay/Buttons/PassBtn
@onready var open_btn: Button = $CanvasLayer/TreasureOverlay/Buttons/OpenBtn
@onready var open_btn_text: Label = $CanvasLayer/TreasureOverlay/Buttons/OpenBtn/Label
@onready var pass_btn_text: Label = $CanvasLayer/TreasureOverlay/Buttons/PassBtn/Label
@onready var open_btn_texture: TextureRect = $CanvasLayer/TreasureOverlay/Buttons/OpenBtn/TextureRect


var current_armor: Armor = null
var current_weapon: Weapon = null
var current_gold_value: int = 0
var is_chest: bool
var chest_ui: bool = false
var player: Player = null
var betterWeapons = {"Crossbow":["Bow","Dagger","Crossbow"], 
					 "Axe":["Club","Dagger","Axe"],
					 "Sword":["Dagger","Sword"], 
					 "Club":["Club"],
					 "Dagger":["Dagger"],
					 "Bow":["Bow"]
}


const FLOATING_TEXT = preload("res://Scenes/FX.tscn")

func spawn_popup(msg: String, color: Color, pos: Vector2) -> Signal:
	var popup: FloatingText = FLOATING_TEXT.instantiate()
	get_tree().current_scene.add_child(popup)
	return popup.setup(msg, color, pos)

func _ready() -> void:
	pass_btn.pressed.connect(_on_pass_pressed)
	open_btn.pressed.connect(_on_open_pressed)

func initialise(p: Player) -> void:
	
	_ready()
	player = p
	setup()

func setup() -> void:
	randomize()
	is_chest = randf() < 2
	
	if is_chest:
		chest_ui = true
		pass_btn.pressed.connect(_on_pass_pressed)
		open_btn.pressed.connect(_on_open_pressed)
		_show_chest_ui()
	else:
		pass_btn.pressed.connect(_on_take_gold_pressed)
		open_btn.pressed.connect(_on_take_item_pressed)
		_show_loot_ui()

func _show_chest_ui() -> void:
	chest_label.text = "You found a Treasure Chest!"
	
	pass_btn.show()
	open_btn.show()

func _show_loot_ui() -> void:
	chest_ui = false
	open_btn.pressed.disconnect(_on_open_pressed)
	pass_btn.pressed.disconnect(_on_pass_pressed)
	pass_btn.pressed.connect(_on_take_gold_pressed)
	open_btn.pressed.connect(_on_take_item_pressed)
	_generate_item_loot()

func _generate_item_loot() -> void:
	current_armor = null
	current_weapon = null
	var player_armor = _get_equipped_armor()
	var player_weapon = _get_equipped_weapon()
	

	var is_armor: bool = randf() < 0.5 
	
	if is_armor:
		
		current_armor = Equipments.armors.pick_random()
		
		current_gold_value = current_armor.goldValue
		chest_label.text = "Loot: " + current_armor.name + " (DEF: " + str(current_armor.defense) + ")"

		if player_armor == null or player_armor.defense < current_armor.defense:
			open_btn_text.text = "Take " + current_armor.name
			open_btn.disabled = false
		else:
			open_btn_text.text = "Current armor is better or similar"
			open_btn.disabled = true
			open_btn_texture.modulate -= Color(1,1,1,0)
			
	else:
		current_weapon = Equipments.weapons.pick_random()

		current_gold_value = current_weapon.goldValue
		chest_label.text = "Loot: " + current_weapon.name + " (DMG: " + str(current_weapon.damage) + ")"
		if player_weapon == null:
			open_btn_text.text = "Take " + current_weapon.name
			open_btn.disabled = false
		elif current_weapon.name in betterWeapons[player_weapon.name]:
			open_btn_text.text = "Current weapon is better"
			open_btn_texture.modulate -= Color(1,1,1,0)
			open_btn.disabled = true
		else:
			open_btn_text.text = "Take " + current_weapon.name
			open_btn.disabled = false

	pass_btn_text.text = "Take " + str(current_gold_value) + " Gold"

func _process(_delta):
	if chest_ui:
		if Input.is_action_just_pressed("attack"):
			_on_open_pressed()
		elif Input.is_action_just_pressed("defend"):
			_on_pass_pressed()
	else:
		if Input.is_action_just_pressed("attack") and open_btn.disabled == false:
			_on_take_item_pressed()
		elif Input.is_action_just_pressed("defend"):
			_on_take_gold_pressed()

func _on_open_pressed() -> void:
	AudioManager.play_sound(AudioManager.SoundType.OPEN_CHEST)
	_show_loot_ui()

func _on_pass_pressed() -> void:
	_finish_room()

func _on_take_item_pressed() -> void:
	
	var base_pos := chest_label.global_position + Vector2(chest_label.size.x / 2.0, -20)
	
	if player:
		if current_armor:
			var old_def: int = 0 if _get_equipped_armor() == null else _get_equipped_armor().defense
			var diff_def: int = current_armor.defense - old_def
			
			player.equipArmor(current_armor)
			updateLabel.emit()
			
			var popup_text := _format_stat_diff(diff_def, "DEF")
			spawn_popup(popup_text, Color(0.3, 0.8, 1.0), base_pos)
			AudioManager.play_sound(AudioManager.SoundType.EQUIP_ARMOR)
			
			
			
		elif current_weapon:
			var old_atk: int = 0 if _get_equipped_weapon() == null else _get_equipped_weapon().damage
			var diff_atk: int = current_weapon.damage - old_atk
			
			player.equipWeapon(current_weapon)
			updateLabel.emit()
			
			var effect_text := ""
			var effect_color := Color.WHITE
			
			if current_weapon.effect != null and current_weapon.effect is Poison:
				effect_text = "+ Bleed"
				effect_color = Color(0.55, 0.12, 0.12) 
			elif current_weapon.stunTime > 0:
				effect_text = "+ Stun"
				effect_color = Color(0.65, 0.25, 0.9) 
			
			if diff_atk != 0:
				var atk_text := _format_stat_diff(diff_atk, "ATK")
				var atk_color := Color(1.0, 0.35, 0.3) if diff_atk < 0 else Color(0.4, 1.0, 0.4)
				
				spawn_popup(atk_text, atk_color, base_pos)
				AudioManager.play_sound(AudioManager.SoundType.EQUIP_WEAPON)
				
				if effect_text != "":
					spawn_popup(effect_text, effect_color, base_pos + Vector2(0, 35))
					
			elif effect_text != "":
				spawn_popup(effect_text, effect_color, base_pos)
			
	_finish_room()

func _on_take_gold_pressed() -> void:
	open_btn.disabled = true
	
	var base_pos := chest_label.global_position + Vector2(chest_label.size.x / 2.0, -20)
	
	if player and current_gold_value > 0:
		player.addGold(current_gold_value)
		updateLabel.emit()
		
		var popup_text := "+%d Gold" % current_gold_value
		spawn_popup(popup_text, Color(1.0, 0.85, 0.2), base_pos)
		AudioManager.play_sound(AudioManager.SoundType.TAKE_GOLD)
		
	_finish_room()

func _finish_room() -> void:
	treasure_chosen.emit()

# ---- Helpers ----

func _get_equipped_armor() -> Armor:
	if player != null and player.armor != null:
		return player.armor
	return null
	
func _get_equipped_weapon() -> Weapon:
	if player != null and player.weapon != null:
		return player.weapon
	return null

func _format_stat_diff(diff: int, stat_name: String) -> String:
	if diff > 0:
		return "+%d %s" % [diff, stat_name]
	elif diff < 0:
		return "%d %s" % [diff, stat_name]
	else:
		return "0 %s" % stat_name
