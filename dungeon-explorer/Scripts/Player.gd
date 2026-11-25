extends Entity
class_name Player

signal died
signal player_healed
var armor: Armor
var weapon: Weapon
var gold: int	
var isDefending: bool
var turnsDefending: int
var owned_minions: Array[Equipments.Minion]

func initialize():
	self.statusEffectManager = StatusEffectManager.new()
	maxHp = 100
	hp = 100
	armor = null
	weapon = null
	gold = 0
	isDefending = false
	turnsDefending = 0
	owned_minions.clear()
	
func get_default_armor() -> Armor:
	for a in Equipments.armors:
		if a.name == "none":
			return a
	return null

func get_default_weapon() -> Weapon:
	for w in Equipments.weapons:
		if w.name == "none":
			return w
	return null

func defend():
	isDefending = true
	turnsDefending = 3

func takeDamage(damage: int) -> int:
	var damageTaken = damage
	#print("Should have taken: ",damageTaken," damage")
	if isDefending:
		damageTaken /= 2
		turnsDefending-= 1
		if turnsDefending <= 0:
			#print("No more defending")
			isDefending = false
	if armor:
		damageTaken -= armor.defense
	if Equipments.Minion.PROTECTION in owned_minions:
		damageTaken -=1
	hp -= max(0,damageTaken)
	#print("Player took damage for: ",max(0,damageTaken), ". Remaining HP: ",hp)
	if hp <= 0:
		die()
	return max(0,damageTaken)
	
func attack() -> int:
	var val: int = 1
	if weapon:
		val = weapon.damage
	if Equipments.Minion.DAMAGE in owned_minions:
		val +=2
	return statusEffectManager.modifyDamage(val)

func equipArmor(newArmor: Armor):
	armor = newArmor

func takeTrueDamage(damage: int):
	hp-=damage
	if hp <= 0:
		die()
	return max(0,damage)
	
func equipWeapon(newWeapon: Weapon):
	weapon = newWeapon

func onNextRoom():
	var hp_copy = hp
	hp = min(hp + 5, maxHp)
	statusEffectManager.onTurnOrRoomEnd(self)
	isDefending = false
	if hp != hp_copy:
		player_healed.emit(hp-hp_copy)

func addGold(goldWon: int):
	gold+= goldWon
	
func getScore():
	var score = gold
	if weapon: score += weapon.goldValue
	if armor: score += armor.goldValue
	return score
	
func addMinion(minion: Equipments.Minion):
	owned_minions.append(minion)

func die():
	died.emit()
