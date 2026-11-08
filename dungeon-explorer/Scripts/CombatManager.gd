class_name CombatManager
extends Node

signal fightWon
signal updateHP

var player: Player
var enemy: Enemy
var enemyFirst: bool

func startCombat(p: Player, e: Entity, enemyAttacksFirst: bool = false):
	player = p
	enemy = e
	enemyFirst = enemyAttacksFirst
	if enemyAttacksFirst:
		enemyTurn()

func playerDefend():
	player.defend()
	enemyTurn()

func playerAttack():
	enemy.takeDamage(player.attack())
	print("Enemy got hit ",player.attack(),". Remaining hp: ",enemy.hp)
	if enemy.hp <= 0:
		endCombat()
		return
	if(player.weapon != null):
		enemy.applyStun(player.weapon.stunTime)
		if(player.weapon.effect != null):
			var effect = player.weapon.effect
			enemy.applyEffect(effect)
			print("Enemy got hit by effect: ",effect.name)
	enemyTurn()
	
func enemyTurn():
	if enemy is Witch:
		var effect = enemy.throwPotion()
		player.applyEffect(effect)
	else:
		player.takeDamage(enemy.attack())
	updateHP.emit()
	if player.hp <= 0:
		endCombat()
		return
	if !enemyFirst:
		player.onTurnEnd()
	else:
		enemyFirst = false
	enemy.onTurnEnd()
	if player.hp <= 0 or enemy.hp <= 0:
		endCombat()
		return
		

func endCombat():
	if player.hp >= 0:
		print("Player won")
		player.addGold(enemy.goldValue)
		fightWon.emit()
	else:
		print("Player not won")
