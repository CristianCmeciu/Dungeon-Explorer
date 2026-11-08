extends FightEvent

@onready var texture: TextureRect = $TextureRect
@onready var witch: Witch = $Witch
@onready var witchMenu: Control = $WitchMenu

signal ranFromWitch

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	attackBttn.hide()
	defendBttn.hide()
	texture.global_position = get_viewport().get_visible_rect().size/2
	witch.activateEnemy(15,0,0)
	startFight(witch,true)

func retaliate():
	witchMenu.hide()
	attackbtn.show()
	defendbtn.show()

func run():
	ranFromWitch.emit()
