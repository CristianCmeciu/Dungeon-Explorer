extends FightEvent

@onready var skeleton: Skeleton = $Skeleton
@onready var texture: TextureRect = $TextureRect
@onready var swordTexture: TextureRect = $Sword
@onready var daggerTexture: TextureRect = $Dagger
var hasSword: bool = false

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	texture.global_position = get_viewport().get_visible_rect().size/2
	if (hasSword):
		swordTexture.show()
		skeleton.activateEnemy(20,8,0)
	else:
		daggerTexture.show()
		skeleton.activateEnemy(20,3,0)
	startFight(skeleton)
