class_name Entity
extends Node

var statusEffectManager: StatusEffectManager
var hp: int
var maxHp: int

func _ready():
	statusEffectManager = StatusEffectManager.new()
	
func applyEffect(effect: StatusEffect):
	if effect != null:
		print(name," got hit by a potion: ",effect.name)
		statusEffectManager.applyEffect(effect, self)

func onTurnEnd():
	statusEffectManager.onTurnOrRoomEnd(self)
