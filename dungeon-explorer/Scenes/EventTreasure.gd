extends Node2D

signal room_completed(next_event: String)
signal room_died

# UI References matching your node hierarchy
@onready var item_node: Node = $Item
@onready var item_description_label: Label = $Item/VBoxContainer/ItemDescriptionLabel
@onready var take_item_btn: Button = $Item/VBoxContainer/TakeItemBtn
@onready var take_gold_btn: Button = $Item/VBoxContainer/TakeGoldBtn

@onready var chest_node: Node = $TreasureChest
@onready var chest_label: Label = $TreasureChest/VBoxContainer/Label
@onready var pass_btn: Button = $TreasureChest/VBoxContainer/PassBtn
@onready var open_btn: Button = $TreasureChest/VBoxContainer/OpenBtn


# Data references
var player: Player
var current_armor: Armor = null
var current_weapon: Weapon = null
var current_gold_value: int = 0

func _ready() -> void:
	# Connect UI buttons
	take_item_btn.pressed.connect(_on_take_item_pressed)
	take_gold_btn.pressed.connect(_on_take_gold_pressed)
	pass_btn.pressed.connect(_on_pass_pressed)
	open_btn.pressed.connect(_on_open_pressed)

func setup(my_event: String = "") -> void:
	player = get_tree().get_first_node_in_group("player")
	
	randomize()
	var is_chest: bool = randf() < 0.5
	
	if is_chest:
		_show_chest_ui()
	else:
		_show_loot_ui()

# --- Room States ---

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
	
	var is_armor: bool = randf() < 0.5
	
	if is_armor and not Equipments.armors.is_empty():
		# Pick a random armor from Equipments array
		current_armor = Equipments.armors.pick_random()
		current_gold_value = current_armor.goldValue
		
		item_description_label.text = "Loot: " + current_armor.name + " (DEF: " + str(current_armor.defense) + ")"
		take_item_btn.text = "Take " + current_armor.name
		
	elif not Equipments.weapons.is_empty():
		# Pick a random weapon from Equipments array
		current_weapon = Equipments.weapons.pick_random()
		# Assign gold value (fallback to 100 if not set in resource)
		current_gold_value = current_weapon.damage * 30
		
		item_description_label.text = "Loot: " + current_weapon.name + " (ATK: " + str(current_weapon.damage) + ")"
		take_item_btn.text = "Take " + current_weapon.name

	# Equal gold alternative choice
	take_gold_btn.text = "Take " + str(current_gold_value) + " Gold"
	take_item_btn.show()
	take_gold_btn.show()

# --- Button Actions ---

func _on_pass_pressed() -> void:
		_finish_room()

func _on_open_pressed() -> void:
	_show_loot_ui()
	

func _on_take_item_pressed() -> void:
	if player:
		if current_armor:
			player.equipArmor(current_armor)
		elif current_weapon:
			player.equipWeapon(current_weapon)
	_finish_room()

func _on_take_gold_pressed() -> void:
	if player and current_gold_value > 0:
		player.getGold(current_gold_value)
	_finish_room()

func _finish_room() -> void:
	room_completed.emit("nimic")
