class_name Poison
extends StatusEffect

var damage: int = 2
var initialDamage: int = 0

func onApply(target: Node):
	target.takeDamage(initialDamage)
	
func onTurnOrRoomEnd(target: Node):
	target.takeDamage(damage)
