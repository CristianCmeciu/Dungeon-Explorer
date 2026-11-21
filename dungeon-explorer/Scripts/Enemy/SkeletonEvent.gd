extends FightEvent

@onready var skeleton: Skeleton = $Skeleton
var hasSword: bool = false

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player,label: Label,hpRect:ColorRect):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	hasSword = randi() % 4 < 1
	if (hasSword):
		skeleton.activateEnemy(20,8,200)
	else:
		skeleton.activateEnemy(20,3,100)
	startFight(skeleton,label,hpRect)
