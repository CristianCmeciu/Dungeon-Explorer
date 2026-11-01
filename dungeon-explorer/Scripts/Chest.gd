extends Node2D

@onready var player: Player = $Player
@onready var combatManager: CombatManager = $CombatManager
@onready var button: Button = $Chest/Button
@onready var mimic: Enemy = $Chest/Mimic

func _ready():
	button.pressed.connect(openChest)

func openChest():
	print ("caca")
	player.initialize()
	mimic.activateEnemy(40,0)
	combatManager.startCombat(player,mimic,true)
	button.visible = false
