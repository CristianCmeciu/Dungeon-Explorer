extends Node2D

signal exitFight

#var player: Player
@onready var player: Player = $Player
@onready var combatManager: CombatManager = $CombatManager
@onready var attackbtn: Button = $AttackBtn
@onready var defendbtn: Button = $DefendBtn
@export var mimicFight: PackedScene

func _ready():
	combatManager.fightWon.connect(fightWon)

func generateEnemy(event: String, _player: Player = null):
	#player = playerIn
	if event == "mimic fight":
		var fightEvent = mimicFight.instantiate()
		add_child(fightEvent)
		fightEvent.global_position = get_viewport_rect().size/2
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player)

func fightWon():
	exitFight.emit()
