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
	var damageTaken = damage
	if armor:
		damageTaken -= armor.defense
	hp -= max(0, damageTaken)
	
func attack() -> int:
	if weapon:
		return statusEffectManager.modifyDamage(weapon.damage)
	return statusEffectManager.modifyDamage(1)

func equipArmor(newArmor: Armor):
	armor = newArmor
	
func equipWeapon(newWeapon: Weapon):
	weapon = newWeapon

func onNextRoom():
	hp = min(hp + 5, maxHp)
	statusEffectManager.onTurnOrRoomEnd(self)
	
func onTurnEnd():
	statusEffectManager.onTurnOrRoomEnd(self)

func applyEffect(effect: StatusEffect):
	statusEffectManager.applyEffect(effect, self)

func getGold(goldWon: int):
	gold+= goldWon
