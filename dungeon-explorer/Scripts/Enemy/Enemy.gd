class_name Enemy
extends Entity

var damage: int

func activateEnemy(enemyHp: int, enemyDamage: int):
	hp = enemyHp
	damage = enemyDamage
	
func attack() -> int:
	return randi_range(2,3)

func takeDamage(damageTaken: int):
	hp-=damageTaken
	if hp <= 0:
		die()
		
func die():
	queue_free()
