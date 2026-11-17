extends FightEvent

@onready var witch: Witch = $Witch
@onready var witchMenu: CanvasLayer = $CanvasLayer

signal ranFromWitch
var fight: bool = false
func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager,playerIn: Player,label: Label,hpRect:ColorRect):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	text = label
	hpLeft = hpRect
	attackBttn.hide()
	defendBttn.hide()
	witch.activateEnemy(15,0,0)
	startFight(witch,label,hpLeft,true)

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
