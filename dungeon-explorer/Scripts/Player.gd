extends Entity
class_name Player

var armor: Armor
var weapon: Weapon
var gold: int	
var isDefending: bool
var turnsDefending: int

func initialize():
	maxHp = 100
	hp = 100
	armor = null
	weapon = null
	gold = 0
	isDefending = false
	turnsDefending = 0
	
func defend():
	isDefending = true
	turnsDefending = 3

func takeDamage(damage: int) -> int:
	var damageTaken = damage
	print("Should have taken: ",damageTaken," damage")
	if isDefending:
		damageTaken /= 2
		turnsDefending-= 1
		if turnsDefending <= 0:
			print("No more defending")
			isDefending = false
	if armor:
		damageTaken -= armor.defense
	hp -= max(0,damageTaken)
	print("Player took damage for: ",max(0,damageTaken), ". Remaining HP: ",hp)
	if hp <= 0:
		die()
	return damageTaken
	
func attack() -> int:
	if weapon:
		return statusEffectManager.modifyDamage(weapon.damage)
	return statusEffectManager.modifyDamage(1)

func equipArmor(newArmor: Armor):
	print("equipped armor: ",newArmor.name)
	armor = newArmor
	
func equipWeapon(newWeapon: Weapon):
	weapon = newWeapon

func onNextRoom():
	hp = min(hp + 5, maxHp)
	statusEffectManager.onTurnOrRoomEnd(self)
	isDefending = false

func addGold(goldWon: int):
	gold+= goldWon

func die():
	pass
