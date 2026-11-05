class_name CombatManager
extends Node

signal fightWon
signal updateHP

var player: Player
var enemy: Enemy

func startCombat(p: Player, e: Entity, enemyAttacksFirst: bool = false):
	player = p
	enemy = e
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
	enemyTurn()
	
func enemyTurn():
	var damageTaken = player.takeDamage(enemy.attack())
	print("Player got hit: ",damageTaken,". Remaining hp: ",player.hp)
	updateHP.emit()
	if player.hp <= 0:
		endCombat()
		return
	player.onTurnEnd()
	enemy.onTurnEnd()
	if player.hp <= 0 or enemy.hp <= 0:
		endCombat()
		return

func endCombat():
	if player.hp >= 0:
		print("Player won")
		fightWon.emit()
	else:
		print("Player not won")
