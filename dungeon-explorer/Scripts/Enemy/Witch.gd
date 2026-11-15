extends Enemy
class_name Witch

func _ready():
	statusEffectManager = StatusEffectManager.new()

func throwPotion() -> StatusEffect:
	if timeStunned >0:
		timeStunned-=1
		wasStunned = true
		return
	var rand = randi_range(0,2)
	match rand:
		0:
			return Poison.new(5)
		1:
			return Blindness.new()
		_:
			return Weakness.new()

	#return possibleEffects[1]
