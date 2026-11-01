extends Entity
class_name Player

var armor: Armor
var weapon: Weapon
var gold: int
	
func takeDamage(damage: int):
	var damageTaken = damage
	if armor:
		damageTaken -= armor.defense
	hp -= damageTaken
	if hp <= 0:
		die()
	
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

func getGold(goldWon: int):
	gold+= goldWon

func die():
	pass
