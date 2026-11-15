extends FightEvent

@onready var texture: TextureRect = $TextureRect
@onready var witch: Witch = $Witch
@onready var witchMenu: Control = $WitchMenu

signal ranFromWitch
var fight: bool = false

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
	fight = true
	witchMenu.hide()
	attackbtn.show()
	defendbtn.show()
	
func _process(_delta):
	if fight:
		return
	
	if Input.is_action_just_pressed("attack"):
		retaliate()
	elif Input.is_action_just_pressed("defend"):
		run()

func run():
	ranFromWitch.emit()
