extends FightEvent

@onready var openButton: Button = $Button
@onready var mimic: Mimic = $Mimic

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager, playerIn: Player):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	attackbtn.hide()
	defendbtn.hide()

func openChest():
	mimic.activateEnemy(40,0)
	startFight(mimic)
	openButton.visible = false
