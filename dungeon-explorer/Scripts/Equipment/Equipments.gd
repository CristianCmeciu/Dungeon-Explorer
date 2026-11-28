extends Node

var armors: Array[Armor] = []
var weapons: Array[Weapon] = []
enum Minion{DAMAGE,PROTECTION,POTION,STUN,FORESIGHT}

func _ready():
	create_armors()
	create_weapons()
	
func create_armors():
	create_armor("Leather Armor",1,100,"res://Assets/armor_leather_1.0.png" )
	create_armor("Chainmail Armor",2,200, "res://Assets/armor_chainmail_1.0.png")
	create_armor("Plate Armor",3,300,"res://Assets/armor_plate_1.0.png" )
	
func create_weapons():
	create_weapon("Club",1,50, "res://Assets/club_1.0.png",1)
	create_weapon("Dagger",3,50, "res://Assets/dagger_1.0.png")
	create_weapon("Sword",8,350, "res://Assets/sword_1.0.png")
	create_weapon("Axe",5,300,"res://Assets/axe_1.0.png",1)
	create_weapon("Bow",2, 150, "res://Assets/bow.png",0, Poison.new())
	create_weapon("Crossbow",6,300,"res://Assets/crossbow.png", 0, Poison.new())
	
func create_armor(armorName: String, defense: int, goldValue: int, string: String):
	var armor = Armor.new()
	armor.name = armorName
	armor.defense = defense
	armor.goldValue = goldValue
	armor.imgPath = string
	armors.append(armor)
	
func create_weapon(weaponName: String, damage: int, goldValue: int, imgPath: String, stunTime: int = 0, statusEffect: StatusEffect = null):
	var weapon = Weapon.new()
	weapon.name = weaponName
	weapon.damage = damage
	weapon.goldValue = goldValue
	weapon.stunTime = stunTime
	weapon.effect = statusEffect
	weapon.imgPath = imgPath
	weapons.append(weapon)
