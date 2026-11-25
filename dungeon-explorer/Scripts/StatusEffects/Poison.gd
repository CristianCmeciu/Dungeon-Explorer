class_name Poison
extends StatusEffect

var damage: int = 2
var initialDamage: int
func _init(initDamage:int = 0):
	initialDamage = initDamage
	name = "Poison"
	duration = 2

func onApply(target: Node):
	target.takeTrueDamage(initialDamage)
	
func onTurnOrRoomEnd(target: Node):
	duration -=1
	target.takeTrueDamage(damage)
