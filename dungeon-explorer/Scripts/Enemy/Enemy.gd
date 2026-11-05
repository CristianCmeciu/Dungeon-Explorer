class_name Enemy
extends Entity

signal died
var damage: int

func activateEnemy(enemyHp: int, enemyDamage: int = 0):
	hp = enemyHp
	damage = enemyDamage
	
func attack() -> int:
	return damage

func takeDamage(damageTaken: int):
	hp-=damageTaken
	if hp <= 0:
		die()
		
func die():
	died.emit()
