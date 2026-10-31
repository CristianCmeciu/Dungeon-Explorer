extends Node

var armors: Array[Armor] = []
var weapons: Array[Weapon] = []

func _ready():
	create_armors()
	create_weapons()
	
func create_armors():
	create_armor("Leather Armor",1)
	create_armor("Chainmail Armor",2)
	create_armor("Plate Armor",3)
	
func create_weapons():
	create_weapon("Club",1,1)
	create_weapon("Dagger",3)
	create_weapon("Sword",8)
	create_weapon("Axe",5,1)
	create_weapon("Bow",4, 0, Poison.new())
	create_weapon("Crossbow",6,0, Poison.new())
	
func create_armor(armorName: String, defense: int):
	var armor = Armor.new()
	armor.name = armorName
	armor.defense = defense
	armors.append(armor)
	
func create_weapon(weaponName: String, damage: int, stunTime: int = 0, statusEffect: StatusEffect = null):
	var weapon = Weapon.new()
	weapon.name = weaponName
	weapon.damage = damage
	weapon.stunTime = stunTime
	weapon.effect = statusEffect
	weapons.append(weapon)
