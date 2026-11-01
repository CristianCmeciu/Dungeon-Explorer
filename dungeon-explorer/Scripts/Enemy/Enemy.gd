class_name Enemy
extends Entity

var damage: int

func activateEnemy(enemyHp: int, enemyDamage: int):
	hp = enemyHp
	damage = enemyDamage
	
func attack() -> int:
	return damage

func takeDamage(damageTaken: int):
	hp-=damageTaken
	if hp <= 0:
		die()
		
func die():
	queue_free()
