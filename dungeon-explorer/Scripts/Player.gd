extends Node
class_name Player

var statusEffectManager: StatusEffectManager
var hp: int
var maxHp: int
var armor: Armor
var weapon: Weapon
var gold: int

func _ready():
	statusEffectManager = StatusEffectManager.new()
	
func takeDamage(damage: int):
	hp -= damage - armor.defense
	
func attack() -> int:
	if weapon:
		return statusEffectManager.modifyDamage(weapon.damage)
	return statusEffectManager.modifyDamage(1)
