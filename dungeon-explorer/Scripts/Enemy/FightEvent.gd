extends Node
class_name FightEvent

var attackbtn: Button
var defendbtn: Button
var player: Player
var combatManager: CombatManager
var text: Label
var hpLeft

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player, textLabel: Label,hpRect: ColorRect):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	text = textLabel
	hpLeft = hpRect
	
func startFight(enemy: Enemy,label: Label,hpRect: ColorRect, enemyAttacksFirst: bool = false):
	attackbtn.show()
	defendbtn.show()
	combatManager.startCombat(player,enemy,label,hpRect,enemyAttacksFirst)
	
