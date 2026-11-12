extends Node

var armors: Array[Armor] = []
var weapons: Array[Weapon] = []

func _ready():
	create_armors()
	create_weapons()
	
func create_armors():
	create_armor("none", 0, 0)
	create_armor("Leather Armor",1,100)
	create_armor("Chainmail Armor",2,200)
	create_armor("Plate Armor",3,300)
	
func create_weapons():
	create_weapon("Club",1,50,1)
	create_weapon("Dagger",3,50)
	create_weapon("Sword",8,350)
	create_weapon("Axe",5,300,1)
	create_weapon("Bow",4, 150,0, Poison.new())
	create_weapon("Crossbow",6,300,0, Poison.new())
	
func create_armor(armorName: String, defense: int, goldValue: int):
	var armor = Armor.new()
	armor.name = armorName
	armor.defense = defense
	armor.goldValue = goldValue
	armors.append(armor)
	
func create_weapon(weaponName: String, damage: int, goldValue: int, stunTime: int = 0, statusEffect: StatusEffect = null):
	var weapon = Weapon.new()
	weapon.name = weaponName
	weapon.damage = damage
	weapon.goldValue = goldValue
	weapon.stunTime = stunTime
	weapon.effect = statusEffect
	weapons.append(weapon)
