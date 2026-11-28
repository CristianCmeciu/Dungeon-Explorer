class_name Entity
extends Node

signal died
var statusEffectManager: StatusEffectManager
var hp: int
var maxHp: int

func _ready():
	statusEffectManager = StatusEffectManager.new()
	
func applyEffect(effect: StatusEffect):
	if effect != null:
		#print(name," got hit by a potion: ",effect.name)
		statusEffectManager.applyEffect(effect, self)

func onTurnEnd():
	statusEffectManager.onTurnOrRoomEnd(self)
	
func takeTrueDamage(damage: int) -> int:
	hp-=damage
	if hp <= 0:
		die()
	return max(0,damage)

func die():
	died.emit()
