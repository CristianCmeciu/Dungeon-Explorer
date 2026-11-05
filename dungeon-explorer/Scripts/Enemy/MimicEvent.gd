extends FightEvent

@onready var openButton: Button = $Button
@onready var mimic: Mimic = $Mimic
@onready var chest_node: Node = $TreasureChest
@onready var chest_label: Label = $TreasureChest/VBoxContainer/Label
@onready var pass_btn: Button = $TreasureChest/VBoxContainer/PassBtn
@onready var open_btn: Button = $TreasureChest/VBoxContainer/OpenBtn


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

func openChest():
	mimic.activateEnemy(40,0)
	startFight(mimic)
	openButton.visible = false

func passChest():
	passChestSignal.emit()
