class_name StatusEffectManager
extends RefCounted

var activeEffects: Array[StatusEffect] = []

func applyEffect(effect: StatusEffect, target: Node):
	for activeEffect in activeEffects:
		if activeEffect.name == effect.name:
			activeEffects.remove_at(activeEffects.find(activeEffect))
	activeEffects.append(effect)
	effect.onApply(target)

func onTurnOrRoomEnd(target: Node):
	for effect in activeEffects:
		effect.onTurnOrRoomEnd(target)
		effect.duration -= 1
		if effect.duration == 0:
			activeEffects.remove_at(activeEffects.find(effect))

func hasEffect(effectName: String) -> bool:
	for effect in activeEffects:
		if effect.name == effectName:
			return true
	return false

func modifyDamage(damage: int) -> int:
	for effect in activeEffects:
		if effect.name == "Weakness":
			return effect.modifyDamage(damage)
	return damage
