class_name Weakness
extends StatusEffect

var damageReduced: int = 3

func _init():
	name = "Weakness"
	duration = 2

func modifyDamage(damage: int) -> int:
	return max(0,damage - damageReduced)
	
