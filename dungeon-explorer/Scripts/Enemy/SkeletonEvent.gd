extends FightEvent

@onready var skeleton: Skeleton = $Skeleton
var hasSword: bool = false

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player,label: Label,hpRect:ColorRect):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	if (hasSword):
		skeleton.activateEnemy(20,8,0)
	else:
		skeleton.activateEnemy(20,3,0)
	startFight(skeleton,label,hpRect)
