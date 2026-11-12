extends Node
class_name FightEvent

var attackbtn: Button
var defendbtn: Button
var player: Player
var combatManager: CombatManager

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn

func startFight(enemy: Enemy,enemyAttacksFirst: bool = false):
	attackbtn.show()
	defendbtn.show()
	combatManager.startCombat(player,enemy,enemyAttacksFirst)
	
