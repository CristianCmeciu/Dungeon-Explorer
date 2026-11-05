extends MarginContainer

@onready var hp_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Hp
@onready var gold_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Gold
@onready var armor_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Armor
@onready var weapon_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Weapon

var player: Player

func _process(_delta: float) -> void:
	# Keep searching for the active player in the scene tree
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Player
	
	# Continuously refresh UI values
	if player:
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
