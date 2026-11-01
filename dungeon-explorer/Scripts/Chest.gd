extends Node2D

var player: Player
var combatManager: CombatManager
@onready var mimic: Enemy = $Mimic

func initialize(p: Player, cm: CombatManager):
	player = p
	combatManager = cm

func openChest():
	mimic.activateEnemy(40,randi_range(2,3))
	combatManager.startCombat(player,mimic,true)
