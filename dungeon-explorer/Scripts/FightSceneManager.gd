extends Node2D

signal exitFight
signal updateLabel

var player: Player
@onready var combatManager: CombatManager = $CombatManager
@onready var attackbtn: Button = $AttackBtn
@onready var defendbtn: Button = $DefendBtn
@export var mimicFight: PackedScene

func _ready():
	combatManager.fightWon.connect(fightWon)
	combatManager.updateHP.connect(updateHP)
	

func generateEnemy(event: String, _player: Player = null):
	player = _player
	
	if event == "mimic fight":
		var fightEvent = mimicFight.instantiate()
		fightEvent.passChestSignal.connect(fightWon)
		add_child(fightEvent)
		
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player)

func fightWon():
	exitFight.emit()

func updateHP():
	updateLabel.emit()
	
