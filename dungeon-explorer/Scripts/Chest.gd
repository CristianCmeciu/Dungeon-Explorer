extends Node2D

@export var player: Player
@export var combatManager: CombatManager
@export var button: Button
@onready var mimic: Enemy = $Mimic

func openChest():
	player.initialize()
	mimic.activateEnemy(40,randi_range(2,3))
	combatManager.startCombat(player,mimic,true)
	button.visible = false
