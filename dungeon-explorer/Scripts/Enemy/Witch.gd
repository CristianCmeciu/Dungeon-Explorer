extends Enemy
class_name Witch
var possibleEffects: Array[StatusEffect]

func _ready():
	statusEffectManager = StatusEffectManager.new()
	possibleEffects.append(Poison.new(5))
	possibleEffects.append(Blindness.new())
	possibleEffects.append(Weakness.new())

func throwPotion() -> StatusEffect:
	return possibleEffects[randi_range(0,2)]
