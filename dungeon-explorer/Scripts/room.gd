extends Node2D

signal room_completed(next_event: String)
signal room_died
signal updateLabel

@export var doors: Array[Area2D]
@export var fake_door_label: Label
@export var fight_scene: PackedScene
@export var treasure_room: PackedScene
@export var minion_scene: PackedScene
@onready var bg_image = $bg_image

const FLOATING_TEXT = preload("res://Scenes/FX.tscn")
var my_minion: Equipments.Minion
var player: Player
var blind: bool
var currentEvent: Node2D
var rooms: int
var minions_happened: bool
var thresholds = [20, 35, 60, 70, 75, 80, 90, 100]
#var thresholds = [10,20,40,70,75,75,90,100]
var events = [
	"nimic", "minion room", "treasure room", "usa fache", 
	"witch fight", "trap room", "mimic fight", "skeleton fight"
]

func initialise(p: Player, rooms_cleared: int,m: bool):
	player = p
	rooms = rooms_cleared
	minions_happened = m
	player.player_healed.connect(popup_wrapper)
	player.onNextRoom()

func popup_wrapper(hp: int):
	spawn_popup("+"+str(hp)+"HP", Color.GREEN, Vector2(450,120))
	
func spawn_popup(msg: String, color: Color, pos: Vector2) -> Signal:
	var popup: FloatingText = FLOATING_TEXT.instantiate()
	get_tree().current_scene.add_child(popup)
	return popup.setup(msg, color, pos)

func setup(my_event: String, minion: Equipments.Minion = Equipments.Minion.DAMAGE):
	blind = player.statusEffectManager.hasEffect("Blindness")
	if Equipments.Minion.FORESIGHT in player.owned_minions and !blind:
		apply_foresight()
	
	if my_event == "minion room":
		AudioManager.play_sound(AudioManager.SoundType.MINION_CRY)
	if my_event == "minion room" and !blind:
		currentEvent = minion_scene.instantiate()
		self.add_child(currentEvent)
		currentEvent.initialise(minion,player)
		currentEvent.updateLabel.connect(updateLabels)
		currentEvent.foresight.connect(apply_foresight)
		
	if my_event == "mimic fight" and !blind:
		currentEvent = fight_scene.instantiate()
		self.add_child(currentEvent)
		currentEvent.generateEnemy(my_event,player)
		currentEvent.exitFight.connect(fightWon)
		currentEvent.updateLabel.connect(updateLabels)
		
	if my_event == "skeleton fight":
		currentEvent = fight_scene.instantiate()
		self.add_child(currentEvent)
		currentEvent.generateEnemy(my_event,player)
		currentEvent.exitFight.connect(fightWon)
		currentEvent.updateLabel.connect(updateLabels)
		
	if my_event == "witch fight":
		currentEvent = fight_scene.instantiate()
		self.add_child(currentEvent)
		currentEvent.generateEnemy(my_event,player)
		currentEvent.exitFight.connect(fightWon)
		currentEvent.updateLabel.connect(updateLabels)
		
	if my_event == "trap room":
		room_died.emit()
		return 
		
	if my_event == "treasure room" and !blind: 
		currentEvent = treasure_room.instantiate()
		self.add_child(currentEvent)
		currentEvent.initialise(player)
		currentEvent.treasure_chosen.connect(fightWon)
	
	var random_bun = 4
	if rooms<=3:
		random_bun = randi() % doors.size()
	
	for i in range(doors.size()):
		var future_event = ""
		if i == random_bun:
			future_event = get_random_bun()
		else:
			future_event = get_random_event()
			
		if minions_happened:
			while future_event == "minion room":
				if i == random_bun:
					future_event = get_random_bun()
				else:
					future_event = get_random_event()
		
		if my_event == "usa fache":
			while future_event == "trap room" or (future_event == "minion room" and minions_happened):
				future_event = get_random_event()
		future_event = "minion room"
		doors[i].set_target_event(future_event,true if Equipments.Minion.FORESIGHT in player.owned_minions else false)
		doors[i].clicked.connect(_on_door_clicked)
		doors[i].fake_clicked.connect(_on_fake_door_clicked)
	
	if fake_door_label:
		fake_door_label.hide()
	
	if my_event == "usa fache":
		setup_fake_doors()
	
	updateLabels()

func apply_foresight():
	for door in doors:
		door.applyMinion(true)


func setup_fake_doors():
	
	if doors.size() == 2:
		var fake_index = randi() % 2
		doors[fake_index].is_fake = true
	elif doors.size() == 3:
		var num_fakes = randi() % 2
		
		if num_fakes:
			doors[1].is_fake = true
			var other_fake = 0 if randi() % 2 else 2
			doors[other_fake].is_fake = true
		else:
			var fake_index = randi() % 3
			doors[fake_index].is_fake = true

func get_random_event() -> String:
	
	var roll = randi_range(1, 100)
	var index = thresholds.bsearch(roll)
	index = clampi(index, 0, events.size() - 1)
	return events[index]
	
func get_random_bun() -> String:
	
	var roll = randi_range(1, 70)
	var index = thresholds.bsearch(roll)
	index = clampi(index, 0, events.size() - 5)
	return events[index]

func _on_door_clicked(event_passed_from_door: String):
	if is_instance_valid(currentEvent):
		return
	AudioManager.play_sound(AudioManager.SoundType.NEXT_ROOM)
	room_completed.emit(event_passed_from_door)

func _on_fake_door_clicked():
	if fake_door_label:
		fake_door_label.show()
		AudioManager.play_sound(AudioManager.SoundType.USA_FACHE)
		
		var tween = create_tween()
		tween.tween_interval(0.2)
		tween.tween_callback(func():
			if is_instance_valid(fake_door_label):fake_door_label.hide())
		
func fightWon():
	currentEvent.queue_free()
	currentEvent = null
	updateLabels()

func _process(_delta):
	blind = player.statusEffectManager.hasEffect("Blindness")
	
	if blind:
		bg_image.hide()
		if doors.size() == 3:
			doors[1].hide()
		for door in doors:
			if door.mist_particles:
				door.mist_particles.hide()
	else:
		for door in doors:
			if door.mist_particles:
				door.mist_particles.show()
		bg_image.show()
		if doors.size() == 3:
			doors[1].show()
			
	if is_instance_valid(currentEvent):
		return

	if doors.size()==3:
		if Input.is_action_just_pressed("door_front"):
			if doors[1].is_fake:
				if !doors[1].wasClicked:
					doors[1].pressed()
					_on_fake_door_clicked()
			else:
				_on_door_clicked(doors[1].target_event)
		elif Input.is_action_just_pressed("door_left"):
			if doors[0].is_fake:
				if !doors[0].wasClicked:
					doors[0].pressed()
					_on_fake_door_clicked()
			else:
				_on_door_clicked(doors[0].target_event)
		elif Input.is_action_just_pressed("door_right"):
			if doors[2].is_fake:
				if !doors[2].wasClicked:
					doors[2].pressed()
					_on_fake_door_clicked()
			else:
				_on_door_clicked(doors[2].target_event)
	else:
		if Input.is_action_just_pressed("door_left"):
			if doors[0].is_fake:
				if !doors[0].wasClicked:
					doors[0].pressed()
					_on_fake_door_clicked()
			else:
				_on_door_clicked(doors[0].target_event)
		elif Input.is_action_just_pressed("door_right"):
			if doors[1].is_fake:
				if !doors[1].wasClicked:
					doors[1].pressed()
					_on_fake_door_clicked()
			else:
				_on_door_clicked(doors[1].target_event)

func updateLabels():
	updateLabel.emit()
