class_name Entity
extends Node

var statusEffectManager: StatusEffectManager
var hp: int
var maxHp: int

func _ready():
	statusEffectManager = StatusEffectManager.new()
	
func applyEffect(effect: StatusEffect):
	statusEffectManager.applyEffect(effect, self)

func onTurnEnd():
	statusEffectManager.onTurnOrRoomEnd(self)
