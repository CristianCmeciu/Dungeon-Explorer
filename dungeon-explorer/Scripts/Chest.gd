extends Node2D

@onready var player: Player = $Player
@onready var combatManager: CombatManager = $CombatManager
@onready var button: Button = $Chest/Button
@onready var attackbtn: Button = $Chest/AttackBtn
@onready var defendbtn: Button = $Chest/DefendBtn
@onready var mimic: Enemy = $Chest/Mimic

func _ready():
	button.pressed.connect(openChest)
	attackbtn.hide()
	defendbtn.hide()

func openChest():
	attackbtn.show()
	defendbtn.show()
	player.initialize()
	mimic.activateEnemy(40,0)
	combatManager.startCombat(player,mimic,true)
	button.visible = false
