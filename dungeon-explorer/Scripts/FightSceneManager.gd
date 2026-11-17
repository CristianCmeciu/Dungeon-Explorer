extends Node2D

signal exitFight
signal updateLabel

var player: Player
@onready var combatManager: CombatManager = $CombatManager
@onready var attackbtn: Button = $CanvasLayer/FightOverlay/Buttons/AttackBtn
@onready var defendbtn: Button = $CanvasLayer/FightOverlay/Buttons/DefendBtn
@onready var enemyTexture: TextureRect = $CanvasLayer/FightOverlay/EnemyTexture
@onready var textLabel: Label = $CanvasLayer/FightOverlay/Label
@onready var hpLeft: ColorRect = $CanvasLayer/FightOverlay/EnemyTexture/HPMax/HPLeft
@export var mimicFight: PackedScene
@export var skeletonFight: PackedScene
@export var witchFight: PackedScene

func _ready():
	combatManager.fightWon.connect(fightWon)
	combatManager.updateHP.connect(updateHP)
	

func generateEnemy(event: String, _player: Player = null):
	player = _player
	if event == "mimic fight":
		var fightEvent = mimicFight.instantiate()
		fightEvent.passChestSignal.connect(fightWon)
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player,textLabel,hpLeft)
	if event == "skeleton fight":
		var fightEvent = skeletonFight.instantiate()
		textLabel.text = "You have encountered a skeleton!"
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player,textLabel,hpLeft)
	if event == "witch fight":
		var fightEvent = witchFight.instantiate()
		textLabel.text = "You have encountered a witch!"
		add_child(fightEvent)
		fightEvent.initialise(attackbtn,defendbtn,combatManager,player,textLabel,hpLeft)
		fightEvent.ranFromWitch.connect(fightWon)
		
func fightWon():
	exitFight.emit()

func updateHP():
	updateLabel.emit()
	
