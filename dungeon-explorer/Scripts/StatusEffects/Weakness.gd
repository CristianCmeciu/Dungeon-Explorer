class_name Weakness
extends StatusEffect

var damageReduced: int = 3

func modifyDamage(damage: int) -> int:
	return max(0,damage - damageReduced)
	
