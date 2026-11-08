class_name Enemy
extends Entity

signal died
var damage: int
var timeStunned: int
var goldValue: int

func activateEnemy(enemyHp: int, enemyDamage: int, gold: int):
	hp = enemyHp
	damage = enemyDamage
	goldValue = gold
	timeStunned = -1
	
func attack() -> int:
	if timeStunned >=0:
		timeStunned-=1
		return 0
	return damage

func takeDamage(damageTaken: int):
	hp-=damageTaken
	if hp <= 0:
		die()
		
func die():
	died.emit()
