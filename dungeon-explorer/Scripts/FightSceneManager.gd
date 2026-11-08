extends Node2D

signal exitFight
signal updateLabel

var player: Player
@onready var combatManager: CombatManager = $CombatManager
@onready var attackbtn: Button = $AttackBtn
@onready var defendbtn: Button = $DefendBtn
@onready var background: TextureRect = $TextureRect
@export var mimicFight: PackedScene
@export var skeletonFight: PackedScene
@export var witchFight: PackedScene

func _ready():
	combatManager.fightWon.connect(fightWon)
	combatManager.updateHP.connect(updateHP)
	

func generateEnemy(event: String, _player: Player = null):
	player = _player
	if event == "mimic fight":
		background.hide()
		var fightEvent = mimicFight.instantiate()
		fightEvent.passChestSignal.connect(fightWon)
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player)
		fightEvent.setBackground(background)
	if event == "skeleton fight":
		var fightEvent = skeletonFight.instantiate()
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player)
	if event == "witch fight":
		var fightEvent = witchFight.instantiate()
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player)
		fightEvent.ranFromWitch.connect(fightWon)
func fightWon():
	exitFight.emit()

func updateHP():
	updateLabel.emit()
	
