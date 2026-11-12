extends Node2D

signal treasure_chosen
signal updateLabel

@onready var item_node: Node = $Item
@onready var item_description_label: Label = $Item/VBoxContainer/ItemDescriptionLabel
@onready var take_item_btn: Button = $Item/VBoxContainer/TakeItemBtn
@onready var take_gold_btn: Button = $Item/VBoxContainer/TakeGoldBtn

@onready var chest_node: Node = $TreasureChest
@onready var chest_label: Label = $TreasureChest/VBoxContainer/Label
@onready var pass_btn: Button = $TreasureChest/VBoxContainer/PassBtn
@onready var open_btn: Button = $TreasureChest/VBoxContainer/OpenBtn

var current_armor: Armor = null
var current_weapon: Weapon = null
var current_gold_value: int = 0
var player: Player = null

func _ready() -> void:
	take_item_btn.pressed.connect(_on_take_item_pressed)
	take_gold_btn.pressed.connect(_on_take_gold_pressed)
	pass_btn.pressed.connect(_on_pass_pressed)
	open_btn.pressed.connect(_on_open_pressed)

# Called by room.gd right after currentEvent is instantiated
func initialise(p: Player) -> void:
	player = p
	setup()

func setup() -> void:
	randomize()
	var is_chest: bool = randf() < 0.25
	
	if is_chest:
		_show_chest_ui()
	else:
		_show_loot_ui()


func _show_chest_ui() -> void:
	item_node.hide()
	chest_node.show()
	chest_label.text = "You found a Treasure Chest!"
	
	pass_btn.text = "Don't open Chest"
	open_btn.text = "Open Chest"
	pass_btn.show()
	open_btn.show()

func _show_loot_ui() -> void:
	chest_node.hide()
	item_node.show()
	_generate_item_loot()

func _generate_item_loot() -> void:
	current_armor = null
	current_weapon = null
	var player_armor = _get_equipped_armor()
	var player_weapon = _get_equipped_weapon()
	
	var is_armor: bool = randf() < 0.35
	
	if is_armor and not Equipments.armors.is_empty():
		while true:
			current_armor = Equipments.armors.pick_random()
			if current_armor != player_armor and current_armor != Equipments.armors.get(0):
				break
		current_gold_value = current_armor.goldValue
		
		item_description_label.text = "Loot: " + current_armor.name + " (DEF: " + str(current_armor.defense) + ")"
		if player_armor == null or player_armor.defense < current_armor.defense:
			take_item_btn.text = "Take " + current_armor.name
			take_item_btn.disabled = false
		else:
			take_item_btn.text = "Current armor is better"
			take_item_btn.disabled = true
			
	elif not Equipments.weapons.is_empty():
		while true:
			current_weapon = Equipments.weapons.pick_random()
			if current_weapon != player_weapon and current_weapon != Equipments.weapons.get(0):
				break
		current_gold_value = current_weapon.damage * 30
	if is_armor:
		current_armor = Equipments.armors.pick_random()
		current_gold_value = current_armor.goldValue
		
		if player.armor != null:
			if current_armor.defense <= player.armor.defense:
				item_description_label.text = "Loot: Gold"
				take_item_btn.hide()
			else: 
				item_description_label.text = "Loot: " + current_armor.name + " (DEF: " + str(current_armor.defense) + ")"
				take_item_btn.text = "Take " + current_armor.name
		else: 
			item_description_label.text = "Loot: " + current_armor.name + " (DEF: " + str(current_armor.defense) + ")"
			take_item_btn.text = "Take " + current_armor.name
		
	else:
		current_weapon = Equipments.weapons.pick_random()
		current_gold_value = current_weapon.goldValue
		
		item_description_label.text = "Loot: " + current_weapon.name + " (ATK: " + str(current_weapon.damage) + ")"
		
		#if player_weapon == null or player_weapon.damage < current_weapon.damage:
		take_item_btn.text = "Take " + current_weapon.name
		take_item_btn.disabled = false
		#else:
		#	take_item_btn.text = "Current weapon is better"
		#	take_item_btn.disabled = true

	take_gold_btn.text = "Take " + str(current_gold_value) + " Gold"
	
	take_item_btn.show()
	take_gold_btn.show()


func _on_open_pressed() -> void:
	_show_loot_ui()

func _on_pass_pressed() -> void:
	_finish_room()

func _on_take_item_pressed() -> void:
	# Dezactivăm butoanele ca jucătorul să nu poată apăsa de două ori în timpul animației
	take_item_btn.disabled = true
	take_gold_btn.disabled = true
	
	if player:
		if current_armor:
			var old_def: int = _get_equipped_armor().defense
			var diff_def: int = current_armor.defense - old_def
			
			player.equipArmor(current_armor)
			updateLabel.emit()
			
			var popup_text := _format_stat_diff(diff_def, "DEF")
			await _show_floating_popup(popup_text, Color(0.3, 0.8, 1.0), 0.0) # Albastru deschis
			
		elif current_weapon:
			var old_atk: int = _get_equipped_weapon().damage
			var diff_atk: int = current_weapon.damage - old_atk
			
			player.equipWeapon(current_weapon)
			updateLabel.emit()
			
			var effect_text := ""
			var effect_color := Color.WHITE
			
			if current_weapon.effect != null:
				if current_weapon.effect is Poison:
					effect_text = "+ Bleed"
					effect_color = Color(0.55, 0.12, 0.12) 
				elif current_weapon.text == "Stun":
					effect_text = "+ Stun"
					effect_color = Color(0.65, 0.25, 0.9)
			
			if diff_atk != 0:
				var atk_text := _format_stat_diff(diff_atk, "ATK")
				var atk_color := Color(1.0, 0.35, 0.3) if diff_atk < 0 else Color(0.4, 1.0, 0.4)
				
				if effect_text != "":
					_show_floating_popup(atk_text, atk_color, 0.0)
					await get_tree().create_timer(0.18).timeout
					await _show_floating_popup(effect_text, effect_color, 35.0)
				else:
					await _show_floating_popup(atk_text, atk_color, 0.0)
			
			elif effect_text != "":
				await _show_floating_popup(effect_text, effect_color, 0.0)
			
	_finish_room()

func _on_take_gold_pressed() -> void:
	take_item_btn.disabled = true
	take_gold_btn.disabled = true
	
	if player and current_gold_value > 0:
		player.addGold(current_gold_value)
		updateLabel.emit()
		
		var popup_text := "+%d Gold" % current_gold_value
		await _show_floating_popup(popup_text, Color(1.0, 0.85, 0.2), 0.0) # Auriu
		
	_finish_room()

func _finish_room() -> void:
	treasure_chosen.emit()

# ---- Helpers ----

func _get_equipped_armor() -> Armor:
	if player != null and player.armor != null:
		return player.armor
	return Equipments.armors.get(0)
	
func _get_equipped_weapon() -> Weapon:
	if player != null and player.weapon != null:
		return player.weapon
	return Equipments.weapons.get(0)
	
# --- Floating Text ---

func _show_floating_popup(text_to_show: String, text_color: Color, delay: float) -> void:
	var popup := Label.new()
	popup.text = text_to_show
	popup.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	popup.add_theme_color_override("font_color", text_color)
	popup.add_theme_color_override("font_outline_color", Color.BLACK)
	popup.add_theme_constant_override("outline_size", 4)
	popup.add_theme_font_size_override("font_size", 28)
	
	add_child(popup)
	
	if item_description_label:
		popup.global_position = item_description_label.global_position + Vector2(50, -30 + delay)
	else:
		popup.position = Vector2(500, 300 + delay)
		
	var tween := create_tween()
	tween.set_parallel(true) 
	tween.tween_property(popup, "position:y", popup.position.y - 60, 1.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 0.0, 1.1).set_ease(Tween.EASE_IN)
	
	await tween.finished
	popup.queue_free()



func _format_stat_diff(diff: int, stat_name: String) -> String:
	if diff > 0:
		return "+%d %s" % [diff, stat_name]
	elif diff < 0:
		return "%d %s" % [diff, stat_name] 
	else:
		return "0 %s" % stat_name
