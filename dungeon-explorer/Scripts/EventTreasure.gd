extends Node2D

signal treasure_chosen
signal updateLabel

# UI References
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
	# Connect UI buttons
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
	var player_armor = _get_equipped_armor()
	var player_weapon = _get_equipped_weapon()
	
	var is_armor: bool = randf() < 0.5
	
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
		item_description_label.text = "Loot: " + current_weapon.name + " (ATK: " + str(current_weapon.damage) + ")"
		
		if player_weapon == null or player_weapon.damage < current_weapon.damage:
			take_item_btn.text = "Take " + current_weapon.name
			take_item_btn.disabled = false
		else:
			take_item_btn.text = "Current weapon is better"
			take_item_btn.disabled = true

	take_gold_btn.text = "Take " + str(current_gold_value) + " Gold"
	
	take_item_btn.show()
	take_gold_btn.show()

# --- Button Actions ---

func _on_open_pressed() -> void:
	_show_loot_ui()

func _on_pass_pressed() -> void:
	_finish_room()

func _on_take_item_pressed() -> void:
	if player:
		if current_armor:
			player.equipArmor(current_armor)
		elif current_weapon:
			player.equipWeapon(current_weapon)
		updateLabel.emit() # Updates Main HUD immediately
	_finish_room()

func _on_take_gold_pressed() -> void:
	if player and current_gold_value > 0:
		player.addGold(current_gold_value)
		updateLabel.emit() # Updates Main HUD immediately
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
