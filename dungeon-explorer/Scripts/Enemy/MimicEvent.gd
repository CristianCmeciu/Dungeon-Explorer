extends FightEvent

@onready var mimic: Mimic = $Mimic
@onready var canvasLayer: CanvasLayer = $CanvasLayer
@onready var chest_label: Label = $CanvasLayer/TreasureOverlay/Label
@onready var pass_btn: Button = $CanvasLayer/TreasureOverlay/Buttons/PassBtn
@onready var open_btn: Button = $CanvasLayer/TreasureOverlay/Buttons/OpenBtn
var fight: bool = false

signal passChestSignal

func initialise(attackBttn: Button, defendBttn: Button,combatMngr: CombatManager, playerIn: Player,label: Label,hpRect: ColorRect):
	attackbtn = attackBttn
	defendbtn = defendBttn
	combatManager = combatMngr
	player = playerIn
	text = label
	hpLeft = hpRect
	attackbtn.hide()
	defendbtn.hide()
	canvasLayer.show()
	chest_label.text = "You found a Treasure Chest!"
	
	pass_btn.text = "Don't open Chest"
	open_btn.text = "Open Chest"
	pass_btn.show()
	open_btn.show()

func _process(_delta):
	if fight:
		return
	
	if Input.is_action_just_pressed("attack"):
		openChest()
	elif Input.is_action_just_pressed("defend"):
		passChest()
	

func openChest():
	text.text = "The chest turned out to be a mimic!"
	mimic.activateEnemy(40,0,300)
	fight = true
	startFight(mimic,text,hpLeft,true)
	canvasLayer.hide()

func passChest():
	
	passChestSignal.emit()
