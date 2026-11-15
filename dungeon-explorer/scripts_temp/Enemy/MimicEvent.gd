extends FightEvent

@onready var openButton: Button = $Button
@onready var mimic: Mimic = $Mimic
@onready var chest_node: Node = $TreasureChest
@onready var chest_label: Label = $TreasureChest/VBoxContainer/Label
@onready var pass_btn: Button = $TreasureChest/VBoxContainer/PassBtn
@onready var open_btn: Button = $TreasureChest/VBoxContainer/OpenBtn
var background: TextureRect
var fight: bool = false

signal passChestSignal

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager, playerIn: Player):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	attackbtn.hide()
	defendbtn.hide()
	chest_node.show()
	chest_label.text = "You found a Treasure Chest!"
	
	pass_btn.text = "Don't open Chest"
	open_btn.text = "Open Chest"
	pass_btn.show()
	open_btn.show()

func setBackground(bckgrd: TextureRect):
	background = bckgrd

func _process(_delta):
	if fight:
		return
	
	if Input.is_action_just_pressed("attack"):
		openChest()
	elif Input.is_action_just_pressed("defend"):
		passChest()
	

func openChest():
	mimic.activateEnemy(40,0,0)
	fight = true
	startFight(mimic,true)
	chest_node.hide()
	background.show()

func passChest():
	
	passChestSignal.emit()
