class_name CombatManager
extends Node

var player: Player
var enemy: Enemy

func startCombat(p: Player, e: Entity, enemyAttacksFirst: bool):
	player = p
	enemy = e
	if enemyAttacksFirst:
		enemyTurn()

func playerAttack():
	enemy.takeDamage(player.attack())
	if enemy.hp <= 0:
		endCombat()
		return
	enemyTurn()
	
func enemyTurn():
	player.takeDamage(enemy.attack())
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
	else:
		print("Player not won")
